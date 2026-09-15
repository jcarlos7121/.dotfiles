#!/bin/bash

# Get current display index
current_display=$(yabai -m query --windows --window | jq '.display')

# Get total number of displays
total_displays=$(yabai -m query --displays | jq '. | length')

# Calculate next display (with wraparound)
next_display=$(( (current_display % total_displays) + 1 ))

# Move window to next display
yabai -m window --display $next_display --focus
