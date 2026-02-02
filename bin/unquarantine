#!/usr/bin/env bash
file="$1"
if [ -z "$file" ]; then
  echo "usage: $(basename $0) /Applications/Librewolf.app"
  exit 1
fi
xattr -d com.apple.quarantine $file
