#!/bin/bash
# Toggle whether the FOCUSED window belongs to the scratchpad set. Bound to
# alt - d.
#
#   window already tagged -> release it, back into the bsp tree
#   otherwise             -> tag it with a label derived from the app name
#
# The label is resolved to a free name BEFORE assigning, because yabai refuses
# a label another window already holds:
#     "the given scratchpad is already assigned to a different window!"
# That is a refusal rather than a recoverable error, so a collision has to be
# avoided up front, not handled afterwards.
#
# skhd does not reliably inherit an interactive PATH, so resolve tools here.
export PATH="/opt/homebrew/bin:$PATH"

cur=$(yabai -m query --windows --window 2>/dev/null) || exit 0
cur_id=$(jq -r '.id // empty' <<<"$cur")
[ -n "$cur_id" ] || exit 0

if [ -n "$(jq -r '.scratchpad // ""' <<<"$cur")" ]; then
  yabai -m window "$cur_id" --scratchpad
  exit 0
fi

base=$(jq -r '.app // ""' <<<"$cur" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]')
[ -n "$base" ] || base=window

taken=$(yabai -m query --windows 2>/dev/null | jq -r '.[] | select(.scratchpad != "") | .scratchpad')
label="$base"
n=1
while printf '%s\n' "$taken" | grep -qx -- "$label"; do
  n=$((n + 1))
  label="$base$n"
done

yabai -m window "$cur_id" --scratchpad "$label"
