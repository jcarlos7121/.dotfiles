#!/bin/bash
# yabai signal handler: runs whenever a window (re-)enters a space's bsp tree --
# window_created, window_deminimized, application_visible.
#
# Any of those, while another window in the space is zoomed, leaves the layout
# inconsistent: the zoomed window keeps a frame spanning several tile slots,
# with the newly inserted window drawn underneath it.
#
# Both zoom kinds must be checked. On window_created yabai has ALREADY cleared
# has-fullscreen-zoom by the time the signal fires, but converts it into
# has-parent-zoom -- which makes the window fill its PARENT node (two slots)
# rather than its own. On window_deminimized has-fullscreen-zoom is often still
# set. A handler that checks only one flag misses half the cases. Neither
# `space --balance` nor mirroring clears a zoom flag, so neither fixes this
# alone.

export PATH="/opt/homebrew/bin:$PATH"
HINT=/tmp/yabai_zoom_active

# application_visible is an app-level event and carries no window id, so fall
# back to the focused space.
if [ -n "$YABAI_WINDOW_ID" ]; then
  sp=$(yabai -m query --windows --window "$YABAI_WINDOW_ID" 2>/dev/null | jq -r '.space // empty')
fi
[ -n "$sp" ] || sp=$(yabai -m query --spaces --space 2>/dev/null | jq -r '.index // empty')
[ -n "$sp" ] || exit 0

cleared=0
while read -r id zf zp; do
  [ -n "$id" ] || continue
  [ "$id" = "$YABAI_WINDOW_ID" ] && continue
  [ "$zf" = "true" ] && { yabai -m window "$id" --toggle zoom-fullscreen 2>/dev/null; cleared=1; }
  [ "$zp" = "true" ] && { yabai -m window "$id" --toggle zoom-parent     2>/dev/null; cleared=1; }
done < <(yabai -m query --windows --space "$sp" 2>/dev/null \
  | jq -r '.[] | select(."has-fullscreen-zoom"==true or ."has-parent-zoom"==true)
                | "\(.id) \(."has-fullscreen-zoom") \(."has-parent-zoom")"')

[ "$cleared" = 1 ] || exit 0

# Clearing a flag can leave the window at its old frame. Mirroring the space
# twice is an identity transform (verified frame-for-frame) that forces yabai to
# recompute and re-apply frames, preserving split ratios that --balance resets.
yabai -m space "$sp" --mirror x-axis 2>/dev/null
yabai -m space "$sp" --mirror x-axis 2>/dev/null

if yabai -m query --windows 2>/dev/null | grep -q '"has-fullscreen-zoom":true'; then
  : > "$HINT"
else
  rm -f "$HINT"
fi
