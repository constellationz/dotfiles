#!/usr/bin/bash
# Install the desktop environment and accompanying programs.
# Requires paru to install.

# Install window manager, compositor, login manager, terminal, and editor.
# - Install basic DE programs (sound, fonts, firefox, theming, file viewers)
# - Install themes (gtk, adwaita)
# - Install fonts (mono font, unicode font, emoji font, coding font, extra fonts)
# - Install my code editor of choice
paru -S --noconfirm awesome-git picom ly alacritty neovim  \
    pavucontrol gucharmap firefox lxappearance mupdf mpv \
    arc-gtk-theme adwaita-icon-theme \
    ttf-fira-code nerd-fonts-dejavu-complete noto-fonts-emoji-apple \
    ttf-victor-mono gnu-free-fonts \
    vscodium-bin

# Enable the login manager
sudo systemctl enable ly.service
