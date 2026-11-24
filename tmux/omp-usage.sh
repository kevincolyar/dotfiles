#!/bin/sh
# Prints the usage window that runs out first at its current pace, with its
# percent remaining and time until it resets, e.g. `<icon> 5h 53% 4h8m <sep>',
# for rose-pine's status-right prepend section.  Pace is the window's average
# so far (used / elapsed), so it is noisy right after a reset.  Gold at <=25%
# remaining, love (red) at <=10%, colors taken from rose-pine.tmux.  The
# provider is that of omp's default model role, so per-host config overlays
# are followed; if that provider reports no usage (e.g. xai-oath), the first
# provider that does is shown instead.
#
# tmux redraws every second (the omp spinner in status-bar.sh needs it), but
# this segment only changes per minute, so the rendered segment is cached for
# a minute and printed as-is until then.  A failed `omp usage' run caches an
# empty segment (hidden, retried next minute).

# The tmux server's PATH may lack the Nix profile, where omp and jq live.
PATH="$HOME/.nix-profile/bin:$PATH"

cache="${XDG_CACHE_HOME:-$HOME/.cache}/tmux/omp-usage"

if [ -n "$(find "$cache" -mmin -1 2>/dev/null)" ]; then
    cat "$cache"
    exit 0
fi
mkdir -p "$(dirname "$cache")"

# Temp file + mv: concurrent clients never read a half-written cache.
render() {
    want=$(omp config get modelRoles --json 2>/dev/null \
        | jq -r '.value.default // empty | split("/")[0]' 2>/dev/null)
    # capacity pools all accounts; providers without it fall back to the
    # per-account reports, averaged per window.  A window's reset is its
    # earliest resetsAt across accounts.  Windows with no measurable pace sort
    # last (1e18 ms); ties go to the lowest remaining.
    read -r w p reset <<EOF
$(omp usage --json 2>/dev/null \
    | jq -r --arg want "$want" '
        (now * 1000) as $now
        | [.reports[].provider] as $have
        | (if $have | index($want) then $want else $have[0] end) as $p
        | [.reports[] | select(.provider == $p) | .limits[]] as $lim
        | ($lim | group_by(.window.id)
            | map({key: .[0].window.id, value: {
                d: .[0].window.durationMs,
                r: ([.[].window.resetsAt | select(. != null)] | min),
                f: ([.[].amount.remainingFraction | select(. != null)]
                    | if . == [] then null else add / length end)}})
            | from_entries) as $win
        | ((.capacity[$p] // [])
            | map(select(.accounts > 0)
                | {key: .window, value: (.remainingAccounts / .accounts)})
            | from_entries) as $cap
        | [$win | to_entries[]
            | {w: .key, d: .value.d, r: .value.r,
               f: ($cap[.key] // .value.f)}
            | select(.f != null)
            | ((if .r != null and .d != null
                then .d - (.r - $now) else 0 end)) as $el
            | .eta = (if $el > 0 and .f < 1
                then .f * $el / (1 - .f) else 1e18 end)]
        | min_by([.eta, .f]) // empty
        | "\(.w) \(.f * 100 | round) \((.r // 0) / 1000 | floor)"')
EOF
    [ -n "$reset" ] || return 0

    # Countdown to the window's reset: `2d3h', `3h12m', `45m'; empty if
    # unknown or already passed.
    left=
    if [ "${reset:-0}" -gt 0 ]; then
        s=$((reset - $(date +%s)))
        if [ "$s" -gt 0 ]; then
            d=$((s / 86400)) h=$((s % 86400 / 3600)) m=$((s % 3600 / 60))
            if [ "$d" -gt 0 ]; then left=" ${d}d${h}h"
            elif [ "$h" -gt 0 ]; then left=" ${h}h${m}m"
            else left=" ${m}m"
            fi
        fi
    fi

    case "$(tmux show -gqv @rose_pine_variant)" in
        dawn) gold='#ea9d34' love='#b4367a' ;;
        *)    gold='#f6c177' love='#eb6f92' ;;
    esac

    # Gauge icon (nf-md-gauge); trailing dot matches the date/time separator.
    icon='󰊚'
    sep=' ●'

    if [ "$p" -le 10 ]; then
        printf '#[fg=%s]%s %s %s%%%s#[default]%s' "$love" "$icon" "$w" "$p" "$left" "$sep"
    elif [ "$p" -le 25 ]; then
        printf '#[fg=%s]%s %s %s%%%s#[default]%s' "$gold" "$icon" "$w" "$p" "$left" "$sep"
    else
        printf '%s %s %s%%%s%s' "$icon" "$w" "$p" "$left" "$sep"
    fi
}

render > "$cache.$$" 2>/dev/null
mv -f "$cache.$$" "$cache"
cat "$cache"
