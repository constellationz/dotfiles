#!/usr/bin/bash
# Installs user programs.
# Requires paru.

# Install programs
# - Browser
# - Text viewer
# - Code editor
paru -S --noconfirm chromium \
    xed \
    vscodium-bin
