#!/bin/bash
# yabai signal handler for window_created.
#
# Opening a window in a space that already has a zoomed window leaves the
# layout broken: the previously-zoomed window keeps a frame spanning several
# tile slots, with the new window drawn on top of it. Toggling zoom by hand
# afterwards is what clears it.
#
# The detail that matters: by the time window_created fires, yabai has ALREADY
# cleared has-fullscreen-zoom -- but it converts it into has-parent-zoom on the
# surviving window, which makes that window fill its PARENT node (two slots)
# rather than its own. A handler that checks only has-fullscreen-zoom finds
# nothing to do and exits, leaving the layout broken. Both flags must be
# checked. Neither `space --balance` nor mirroring clears a zoom flag, so
# neither can fix this on its own.

export PATH="/opt/homebrew/bin:$PATH"
HINT=/tmp/yabai_zoom_active

wid="$YABAI_WINDOW_ID"
[ -n "$wid" ] || exit 0

info=$(yabai -m query --windows --window "$wid" 2>/dev/null) || exit 0
sp=$(jq -r '.space // empty' <<<"$info")
[ -n "$sp" ] || exit 0

# Process substitution, not a pipe: a pipe would run the loop in a subshell and
# lose $cleared.
cleared=0
while read -r id zf zp; do
  [ -n "$id" ] || continue
  [ "$id" = "$wid" ] && continue
  [ "$zf" = "true" ] && { yabai -m window "$id" --toggle zoom-fullscreen 2>/dev/null; cleared=1; }
  [ "$zp" = "true" ] && { yabai -m window "$id" --toggle zoom-parent     2>/dev/null; cleared=1; }
done < <(yabai -m query --windows --space "$sp" 2>/dev/null \
  | jq -r '.[] | select(."has-fullscreen-zoom"==true or ."has-parent-zoom"==true)
                | "\(.id) \(."has-fullscreen-zoom") \(."has-parent-zoom")"')

[ "$cleared" = 1 ] || exit 0

# Clearing the flag can leave the window at its old frame. Mirroring the space
# twice is an identity transform (verified frame-for-frame) that forces yabai to
# recompute and re-apply frames, while preserving split ratios that --balance
# would reset to 0.5.
yabai -m space "$sp" --mirror x-axis 2>/dev/null
yabai -m space "$sp" --mirror x-axis 2>/dev/null

# This handler clears zooms, so refresh the hint focus_carry_zoom.sh relies on.
if yabai -m query --windows 2>/dev/null | grep -q '"has-fullscreen-zoom":true'; then
  : > "$HINT"
else
  rm -f "$HINT"
fi
