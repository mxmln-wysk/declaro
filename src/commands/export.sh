#!/usr/bin/env bash

SHRBINDIR=$(dirname $BASH_SOURCE)
source $SHRBINDIR/utils.sh

if [ -z "$1" ]; then
  echo "Error: No output file specified." >&2
  echo "Usage: declarch export <file>" >&2
  exit 1
fi

tar czf "$1" --directory="${ETC_DECLARCH_DIR}" .
