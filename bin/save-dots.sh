#!/usr/bin/bash
# Save dotfiles to the dotfiles repository.

SCRIPT_DIR=$(dirname "$0")
CONFIG_DIR=$SCRIPT_DIR/../config/

dotConfigs=(
    "awesome/"
    "alacritty/"
    "helix/"
    "picom/"
    "paru/"
	"kak/"
    "nvim/"
	"qutebrowser/"
    "fish/"
    "VSCodium/User/settings.json"
)

# Copy configs
for config in ${dotConfigs[@]}; do
    echo "Saving $config"
    rsync -a -r ~/.config/$config $CONFIG_DIR$config
done

# Remove stupid alacritty-themes autogens
if [ -d "~/dotfiles/config/alacritty" ];
then
    echo "Removing alacritty .bak files"
    rm $CONFIG_DIR/alacritty/*.bak
fi

