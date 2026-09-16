#!/bin/bash
# Directional focus that carries zoom-fullscreen with it.
#
# Usage: focus_carry_zoom.sh west|south|north|east
#
# This runs on every navigation keypress, so the common case must be cheap.
# A hint file records whether ANY window is currently zoom-fullscreen; every
# script that can create or clear a zoom keeps it current. When it is absent --
# almost always -- this exec's straight into yabai with no query at all, so the
# only cost over the bare binding is one process spawn.
#
# A stale hint is safe in the direction that matters: if the file exists but
# nothing is actually zoomed (yabai drops a zoom by itself when a window
# closes), the slow path queries, finds nothing, refreshes the hint and does a
# plain focus. One slow keypress, correct result.

export PATH="/opt/homebrew/bin:$PATH"
HINT=/tmp/yabai_zoom_active

dir="$1"
case "$dir" in
  west|south|north|east) ;;
  *) echo "usage: ${0##*/} west|south|north|east" >&2; exit 64 ;;
esac

refresh_hint() {
  if yabai -m query --windows 2>/dev/null | grep -q '"has-fullscreen-zoom":true'; then
    : > "$HINT"
  else
    rm -f "$HINT"
  fi
}

# Fast path: no zoom anywhere. No query, no jq -- just hand off to yabai.
[ -e "$HINT" ] || exec yabai -m window --focus "$dir"

cur=$(yabai -m query --windows --window 2>/dev/null) || exec yabai -m window --focus "$dir"

# Hint is set but the focused window is not the zoomed one: move focus first so
# it still feels immediate, then reconcile the hint.
case "$cur" in
  *'"has-fullscreen-zoom":true'*) ;;
  *) yabai -m window --focus "$dir" 2>/dev/null; refresh_hint; exit 0 ;;
esac

cur_id=${cur#*\"id\":}; cur_id=${cur_id%%,*}

yabai -m window --focus "$dir" 2>/dev/null || exit 0

new=$(yabai -m query --windows --window 2>/dev/null) || exit 0
new_id=${new#*\"id\":}; new_id=${new_id%%,*}
[ "$new_id" = "$cur_id" ] && exit 0

# Zoom the destination first so the old window un-zooms behind it rather than
# flashing the tiled layout. Skip if already zoomed, or we would un-zoom it.
case "$new" in
  *'"has-fullscreen-zoom":true'*) ;;
  *) yabai -m window "$new_id" --toggle zoom-fullscreen ;;
esac
yabai -m window "$cur_id" --toggle zoom-fullscreen
