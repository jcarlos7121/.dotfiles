#!/bin/bash
# yabai signal handler for window_focused.
#
# A zoom-fullscreen window keeps covering the screen after focus moves away:
# click a link in a zoomed mail client and the browser takes focus but stays
# hidden behind it. Treat zoom as a focus mode -- when focus lands on a
# different tiled window, drop the zoom so the layout is visible again.
#
# Focus landing on a floating or unmanaged window is deliberately ignored, so a
# summoned scratchpad, a dialog or a palette does not cost you the zoom.
#
# Explicit zoom-carry on alt - h/j/k/l still works. focus_carry_zoom.sh re-reads
# the old window's state rather than toggling it blind, so whichever of the two
# runs first the result is the same: the destination ends up zoomed, the source
# does not.

export PATH="/opt/homebrew/bin:$PATH"
HINT=/tmp/yabai_zoom_active

# Fast path: nothing zoomed anywhere, nothing to undo. This fires on every focus
# change, so the common case must cost nothing -- a file test, no IPC.
[ -e "$HINT" ] || exit 0

focused=$(yabai -m query --windows --window 2>/dev/null) || exit 0
[ -n "$focused" ] || exit 0

case "$focused" in
  *'"is-floating":true'*) exit 0 ;;
esac

fid=$(jq -r '.id // empty' <<<"$focused")
sp=$(jq -r '.space // empty' <<<"$focused")
[ -n "$fid" ] && [ -n "$sp" ] || exit 0

yabai -m query --windows --space "$sp" 2>/dev/null \
  | jq -r --argjson f "$fid" '.[] | select(."has-fullscreen-zoom" == true and .id != $f) | .id' \
  | while read -r id; do
      [ -n "$id" ] && yabai -m window "$id" --toggle zoom-fullscreen 2>/dev/null
    done

# Only ever SET the hint here, never remove it.
#
# This handler runs concurrently with focus_carry_zoom.sh, which un-zooms the
# window you left and zooms the one you arrived at. Querying in the gap between
# those two steps sees no zoom at all, and removing the hint there deletes a
# flag that is about to be true again. The next alt-h/j/k/l then takes the fast
# path, skips the carry, and leaves a zoomed window covering the screen -- the
# failure looks intermittent because it only bites from the second keypress on.
#
# The asymmetry is what keeps this safe: a hint that lingers costs one extra
# query and corrects itself, while a hint wrongly removed silently disables
# zoom-carry. Stale hints are cleared by the synchronous paths that cannot race
# -- toggle_fullscreen.sh and focus_carry_zoom.sh's own refresh.
if yabai -m query --windows 2>/dev/null | grep -q '"has-fullscreen-zoom":true'; then
  : > "$HINT"
fi
