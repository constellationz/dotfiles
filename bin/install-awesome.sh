#!/usr/bin/bash
# Install awesomewm.

# Install awesomewm, compositor, and login manager.
# Install theme manager and an icon theme.
# Install fonts. 
# - Monospace font
# - Unicode font, 
# - Emoji font, 
# - Monospace font
# - GNU free fonts for anything that's missing.
# Install terminal emulator.
# Install basic file viewers.
# Install a graphical file manager.
# Install volume programs.
# Install network manager programs.
# Install battery manager programs.
# Install brightness manager programs.
paru -S --noconfirm awesome-git picom ly \
    lxappearance adwaita-icon-theme \
    ttf-fira-code nerd-fonts-dejavu-complete noto-fonts-emoji-apple nerd-fonts-victor-mono gnu-free-fonts \
    alacritty \
    gucharmap mupdf mpv feh \
    nemo \
    pavucontrol \
	networkmanager nm-connection-editor \
    powerkit \
    backlight_control 

# Enable the login manager
sudo systemctl enable ly.service

# Enable the network manager
sudo systemctl enable NetworkManager.service
