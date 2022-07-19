#!/usr/bin/bash
# Installs user programs.
# Requires paru.

# Install programs
# - Browsers
# - Text viewers
# - Music players
# - Code editors
paru -S --noconfirm qutebrowser chromium \
    xed \
	ncspot-bin \
    vscodium-bin
