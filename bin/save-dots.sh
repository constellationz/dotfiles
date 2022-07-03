#!/usr/bin/bash
# Save dotfiles to the dotfiles repository.

dotConfigs=(
    "awesome/"
    "alacritty/"
    "helix/"
    "picom/"
    "paru/"
    "nvim/"
    "fish/"
    "VSCodium/User/settings.json"
)

# Copy configs
for config in ${dotConfigs[@]}; do
    echo "Saving $config"
    rsync -a -r ~/.config/$config ~/dotfiles/config/$config
done

# Remove stupid alacritty autogens
if [ -d "~/dotfiles/config/alacritty" ];
then
    echo "Removing alacritty .bak files"
    rm ~/dotfiles/config/alacritty/*.bak
fi
