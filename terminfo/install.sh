#!/bin/sh
# Rebuild ~/.terminfo/74/tmux-256color with undercurl capabilities.
#
# Emacs 31 (also nvim, less, etc.) only emits SGR 4:3 / SGR 58 -- curly and
# colored underlines -- when the terminfo entry for $TERM advertises the
# extended capabilities Smulx and Setulc. Upstream's tmux-256color entry
# carries neither, so anything running inside tmux silently downgrades
# `:underline (:style wave)` to a plain SGR 4.
#
# Ghostty's own xterm-ghostty entry does advertise both, so tmux turns on its
# "usstyle" feature and forwards the sequences to the terminal unchanged --
# the missing half is purely what tmux advertises inward.
#
# Idempotent: always recompiled from the pristine system entry.
set -eu

term=tmux-256color
outdir="${HOME}/.terminfo"

src="$(mktemp -t "${term}.XXXXXX")"
trap 'rm -f "${src}"' EXIT

# Read the base entry from the system database, never from the patched copy
# in ~/.terminfo, so repeated runs cannot accumulate edits.
for db in /usr/share/terminfo /Applications/Ghostty.app/Contents/Resources/terminfo ""; do
    if [ -n "${db}" ]; then
        infocmp -x -A "${db}" "${term}" >"${src}" 2>/dev/null && break
    else
        infocmp -x "${term}" >"${src}"
    fi
done

[ -s "${src}" ] || { echo "terminfo: no ${term} entry found" >&2; exit 1; }

# ncv@ cancels "no color video": without it tmux-derived entries drop
# attributes such as underline when a color is also active.
cat >>"${src}" <<'EOF'
	ncv@,
	Smulx=\E[4\:%p1%dm,
	Setulc=\E[58\:2\:\:%p1%{65536}%/%d\:%p1%{256}%/%{255}%&%d\:%p1%{255}%&%d%;m,
EOF

mkdir -p "${outdir}"
tic -x -o "${outdir}" "${src}"

echo "terminfo: installed ${term} -> ${outdir}"
infocmp -x -A "${outdir}" "${term}" | tr ',' '\n' | grep -E 'Smulx|Setulc'
