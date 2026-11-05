#!/bin/sh
#
# Glow
#
# glow reads its config from ~/Library/Preferences/glow on macOS, outside
# ~/.config, so glow.yml is linked there rather than via *.configlink.

set -e

src="$(cd "$(dirname "$0")" && pwd)/glow.yml"
dst="$HOME/Library/Preferences/glow/glow.yml"

mkdir -p "$(dirname "$dst")"

if [ "$(readlink "$dst")" = "$src" ]
then
  exit 0
fi

if [ -e "$dst" ]
then
  mv "$dst" "$dst.backup"
  echo "  moved $dst to $dst.backup"
fi

ln -s "$src" "$dst"
echo "  linked $src to $dst"
