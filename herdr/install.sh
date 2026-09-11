#!/bin/sh
#
# Herdr
#
# ~/.config/herdr also holds runtime state (sockets, logs, session.json), so
# only config.toml is linked rather than the whole directory via *.configlink.

set -e

src="$(cd "$(dirname "$0")" && pwd)/config.toml"
dst="$HOME/.config/herdr/config.toml"

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
