#!/bin/bash
# Toggle a monocle-style zoom across every tiled window in the focused space.
#
# Zooming only the focused window leaves its neighbours tiled, so navigating
# away with alt-h/j/k/l drops you back into the split layout. Zooming all of
# them instead makes every window render full-size, so focus movement walks
# from one fullscreen window to the next.
#
# Directional focus keeps working because zoom never touches the bsp tree:
# view.c:364 renders a zoomed node at "node->zoom->area" while leaving
# "node->area" alone, and view.c:598 ranks focus candidates by "node->area".
# The tree keeps its spatial layout; only the drawing changes.
#
# While zoomed, windows are promoted to the "above" stacking sub-layer. yabai
# demotes managed (tiled) windows to "below" (sub-level -20) while leaving
# floating and manage=off windows at "normal" (0). Tiled windows never overlap,
# so that ordering is invisible -- until a window fills the display, at which
# point every floating overlay in the space (Granola Nub, TickTick, 1Password,
# Finder, ...) draws on top of it even though it still holds keyboard focus.
# Promoting the whole zoomed set clears those overlays and lets macOS raise
# whichever member currently has focus; "auto" hands the windows back to
# yabai's automatic sub-layer management on un-zoom.
#
# skhd does not reliably inherit an interactive PATH, so resolve tools here.
export PATH="/opt/homebrew/bin:$PATH"

focused=$(yabai -m query --windows --window 2>/dev/null) || exit 0
[ -n "$focused" ] || exit 0

# Native-fullscreen windows live in their own macOS Space; zoom does not apply.
if [ "$(jq -r '."is-native-fullscreen"' <<<"$focused")" = "true" ]; then
  exit 0
fi

space=$(jq -r '.space' <<<"$focused")

# Only leaves of the bsp tree can be zoomed. A window outside the tree --
# floating, minimized, sticky, or manage=off -- reports split-type "none",
# which makes that one field a sufficient test for eligibility.
windows=$(yabai -m query --windows --space "$space" | jq -c '[
  .[] | select(
    .["split-type"] != "none" and
    .["is-floating"] == false and
    .["is-minimized"] == false and
    .["is-native-fullscreen"] == false
  )
]') || exit 0

# window_manager.c:2348 refuses to zoom the root node, so a space holding a
# single tiled window can never change state; bail rather than half-toggle.
# This also covers float-layout spaces, where nothing reports a split-type.
[ "$(jq 'length' <<<"$windows")" -ge 2 ] || exit 0

# Derive the direction from what is actually on screen rather than assuming the
# last toggle succeeded, so a partially-zoomed space heals on the next press.
if [ "$(jq -r 'any(.[]; .["has-fullscreen-zoom"] == true)' <<<"$windows")" = "true" ]; then
  for id in $(jq -r '.[] | select(.["has-fullscreen-zoom"] == true) | .id' <<<"$windows"); do
    yabai -m window "$id" --toggle zoom-fullscreen 2>/dev/null
  done
  for id in $(jq -r '.[].id' <<<"$windows"); do
    yabai -m window "$id" --sub-layer auto 2>/dev/null
  done
else
  for id in $(jq -r '.[] | select(.["has-fullscreen-zoom"] == false) | .id' <<<"$windows"); do
    yabai -m window "$id" --toggle zoom-fullscreen 2>/dev/null
    yabai -m window "$id" --sub-layer above 2>/dev/null
  done
fi
