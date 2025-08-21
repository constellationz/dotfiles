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

# For safe-keeping
mkdir -p ~/Desktop/rsynclog

# One-directional lfs backup
rsync --rsh="ssh -p 1183 -i ~/.ssh/hopper" --archive --verbose --compress --progress --partial ~/Desktop/lfs/ tyler@hopper.local:/media/hdd/tyler/lfs/ | tee -a ~/Desktop/rsynclog/lfs-hopper-log.txt
echo Desktop/lfs/ forward backup complete

# One-directional sync (using forward deletion)
# Make sure to do dry-run before initiating actual transfer
rsync --rsh="ssh -p 1183 -i ~/.ssh/hopper" --archive --delete-before --verbose --compress --progress --partial ~/Desktop/sync/ tyler@hopper.local:/media/hdd/tyler/sync/ | tee -a ~/Desktop/rsynclog/sync-hopper-log.txt
echo Desktop/sync/ forward sync complete
