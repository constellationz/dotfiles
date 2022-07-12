#!/usr/bin/bash
# Install awesomewm.

paru -S --noconfirm awesome-git picom ly \
    lxappearance adwaita-icon-theme \
	networkmanager nm-connection-editor \
    ttf-fira-code nerd-fonts-dejavu-complete noto-fonts-emoji-apple \
    gnu-free-fonts

# Enable the login manager
sudo systemctl enable ly.service

# Enable the network manager
sudo systemctl enable NetworkManager.service

