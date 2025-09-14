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

# For safe-keeping
mkdir -p ~/Desktop/rsynclog

# One-directional sync (using forward deletion)
# Make sure to do dry-run before initiating actual transfer
rsync --rsh="ssh -p 1183 -i ~/.ssh/hopper" --archive --delete-before --verbose --compress --progress --partial --bwlimit=500 ~/Desktop/sync/ tyler@hopper.wg:/media/hdd/tyler/sync/ | tee -a ~/Desktop/rsynclog/sync-hopper-log.txt
echo Desktop/sync/ forward sync complete

# One-directional lfs sync (no deletion)
# rsync --rsh="ssh -p 1183 -i ~/.ssh/hopper" --archive --verbose --compress --progress --partial --bwlimit=500 ~/Desktop/lfs/ tyler@hopper.wg:/media/hdd/tyler/lfs/ | tee -a ~/Desktop/rsynclog/lfs-hopper-log.txt
# echo Desktop/lfs/ forward backup complete

