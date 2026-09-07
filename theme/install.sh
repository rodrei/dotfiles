#!/bin/sh
#
# Render the current theme (or the default) into ~/.config/theme and register
# the iTerm "Theme" profile as the default. Safe to re-run.

"$(dirname "$0")/../bin/theme" setup
