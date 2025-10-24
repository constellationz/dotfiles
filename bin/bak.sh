#!/usr/bin/env bash
# Rsync backup with:
# - ssh using key login
# - archive permissions
# - verbose
# - stream compression
# - progress
# - partial sync
# - 500 kb/s bandwidth limit
# - write to /media/hdd/tyler/lfs
#
# Note: These operations use wireguard
# - Change hopper.wg to hopper.local
# - Optionally remove bandwidth limit

dest="$1"
if [ -z "$dest" ]; then
  echo "usage: $(basename $0) hopper.wg0"
  exit 1
fi
destdir="$(hostname -s)-bak"

# log
echo "syncing to device $dest"
echo "destination directory $destdir"

# For safe-keeping
mkdir -p ~/rsynclog

# One-directional sync (using forward deletion)
# Make sure to do dry-run before initiating actual transfer
rsync --rsh="ssh -p 1183 -i ~/.ssh/hopper" --archive --delete-before --verbose --compress --progress --partial ~/sync/ tyler@$dest:/media/hdd/tyler/$destdir/ | tee -a ~/rsynclog/sync-hopper-log.txt
echo "~/sync/ forward sync complete"
