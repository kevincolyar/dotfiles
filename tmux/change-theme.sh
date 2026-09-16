#!/bin/sh
# Switch the rose-pine variant (main | moon | dawn) and re-render the bar.
# Setting @rose_pine_variant alone changes nothing: the plugin reads it once,
# at render time.
set -e

tmux set -g @rose_pine_variant "$1"
exec "$(dirname "$0")/status-bar.sh"
