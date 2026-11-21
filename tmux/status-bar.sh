#!/bin/sh
# Renders the rose-pine bar, then applies what the theme has no options
# for:
#   - the left section shows the short hostname (#h) instead of the session
#     name (#S), which show_session in rose-pine.tmux hardcodes;
#   - the window index is dimmed so it reads apart from the window name.
#     `dim' is an attribute, not a color, so it holds across every variant;
#   - a spinner follows the window name while omp works in the active pane.
#     omp titles the pane `π > …' when idle and `π <spinner> …' when working;
#     the spinner glyph (3rd character) is copied, so it animates with omp.
#     omp's 6-dot frames sit high in the braille cell, so its 10 frames are
#     mapped onto a centered 4-dot spinner (middle 2x2, gap turning clockwise).
#
# The plugin is run from here instead of leaning on tpm's run: tpm's job and a
# separate `run-shell' in .tmux.conf are two tmux clients, so the plugin's
# `set -g status-left' can land after the rewrite and clobber it.  One shell,
# sequential tmux calls, no race.
#
# Idempotent: each run re-renders the theme first, then rewrites it again.
set -e

"${HOME}/.tmux/plugins/tmux/rose-pine.tmux"

tmux set -g status-left "$(tmux show -gv status-left | sed 's/#S/#h/g')"

busy='#{&&:#{m:π *,#{pane_title}},#{!:#{m:π >*,#{pane_title}}}}'
glyph='#{=-1:#{=3:pane_title}}'
spinner="$glyph"
for pair in ⠋:⠴ ⠙:⠴ ⠹:⠴ ⠸:⠦ ⠼:⠦ ⠴:⠖ ⠦:⠖ ⠧:⠖ ⠇:⠲ ⠏:⠲; do
    spinner="#{?#{==:$glyph,${pair%:*}},${pair#*:},$spinner}"
done

for opt in window-status-format window-status-current-format; do
    tmux set -gw "$opt" \
        "$(tmux show -gwv "$opt" | sed 's/#I/#[dim]#I#[nodim]/')#{?$busy, $spinner,}"
done
