#!/usr/bin/bash
# Install awesomewm.

# Install awesomewm, compositor, and login manager.
# Install theme managers and an icon theme.
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
# Install bluetooth manager programs.
# Install battery manager programs.
# Install brightness manager programs.
paru -S --noconfirm awesome-git picom ly \
    lxappearance qt5ct adwaita-icon-theme \
    ttf-fira-code nerd-fonts-dejavu-complete noto-fonts-emoji-apple nerd-fonts-victor-mono gnu-free-fonts \
    alacritty \
    gucharmap mupdf mpv feh \
    nemo \
    pavucontrol mictray volumeicon-gtk2 alsa-utils \
	networkmanager nm-connection-editor network-manager-applet \
    bluez bluez-utils blueman \
    powerkit \
    backlight_control \

# Enable the login manager
sudo systemctl enable ly.service

# Enable the network manager
sudo systemctl enable NetworkManager.service

# Enable bluetooth
sudo systemctl enable bluetooth.service
