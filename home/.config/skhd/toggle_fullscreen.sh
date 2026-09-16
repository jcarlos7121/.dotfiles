#!/bin/bash
# Toggle zoom-fullscreen on the FOCUSED window only.
#
# Deliberately does NOT touch the window's stacking sub-layer. yabai orders
# managed (tiled) windows at sub-layer "below" (-20) and unmanaged/floating ones
# at "normal" (0). That gap is what makes dialogs and palettes render over a
# tiled window; promoting the zoomed window above it buries every small window
# opened afterwards, and cannot reach real always-on-top overlays anyway.
#
# skhd does not reliably inherit an interactive PATH, so resolve tools here.
export PATH="/opt/homebrew/bin:$PATH"
HINT=/tmp/yabai_zoom_active

yabai -m window --toggle zoom-fullscreen

# Keep the zoom hint current: focus_carry_zoom.sh reads it to skip a yabai query
# on every navigation keypress. Costs one query here, but only when zooming.
if yabai -m query --windows 2>/dev/null | grep -q '"has-fullscreen-zoom":true'; then
  : > "$HINT"
else
  rm -f "$HINT"
fi
