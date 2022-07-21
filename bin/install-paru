#!/usr/bin/bash
# Install the paru AUR helper.
# Requires elevated privileges.

sudo pacman -S --noconfirm git
mkdir -p ~/.git
cd ~/.git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

