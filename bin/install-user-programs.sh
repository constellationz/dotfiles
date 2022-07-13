#!/usr/bin/bash
# Installs user programs.
# Requires paru.

# Install programs
# - Browser
# - Latex editor
# - Text viewer
# - Code editor
paru -S --noconfirm chromium \
    kile \
    xed \
    vscodium
