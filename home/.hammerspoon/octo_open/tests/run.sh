#!/bin/sh
# Runs every spec with plain lua. Run from anywhere:  ~/.hammerspoon/octo_open/tests/run.sh
set -e
cd "$(dirname "$0")/../.."
status=0
for spec in octo_open/tests/*_spec.lua; do
  printf '%s ' "$(basename "$spec")"
  lua "$spec" || status=1
done
exit $status
