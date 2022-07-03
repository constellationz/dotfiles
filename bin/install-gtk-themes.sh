#!/bin/bash

HOME_FOLDER=~
REP_FOLDER=$HOME_FOLDER/.rep
THEME_FOLDER=$HOME_FOLDER/.themes

# Install git
echo "Making sure git is installed..."
sudo pacman -S --needed --noconfirm make git 

# Make sure the .rep directory exists
mkdir -p $REP_FOLDER
mkdir -p $THEME_FOLDER

# Copy these git repos
git clone https://github.com/vinceliuice/Graphite-gtk-theme $REP_FOLDER/Graphite-gtk-theme
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme $REP_FOLDER/Gruvbox-gtk-theme

# Run install scripts for gtk
# Install light and dark normal themes (rimless)
$REP_FOLDER/Graphite-gtk-theme/install.sh --tweaks rimless --theme blue --color dark
$REP_FOLDER/Graphite-gtk-theme/install.sh --tweaks rimless --theme blue --color light

# Install light and dark nord themes (rimless)
$REP_FOLDER/Graphite-gtk-theme/install.sh --tweaks nord rimless --theme blue --color dark
$REP_FOLDER/Graphite-gtk-theme/install.sh --tweaks nord rimless --theme blue --color light

# Install gruvbox theme
cp -r $REP_FOLDER/Gruvbox-gtk-theme/themes/Gruvbox-Dark $THEME_FOLDER/Gruvbox-Dark
cp -r $REP_FOLDER/Gruvbox-gtk-theme/themes/Gruvbox-Light $THEME_FOLDER/Gruvbox-Light
