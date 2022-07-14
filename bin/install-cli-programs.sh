#!/usr/bin/bash
# Installs useful CLI programs.
# Requires paru.

# Install programs
# - Shell
# - Git tools
# - Editors
# - File managers
# - Management programs
paru -S --noconfirm fish man \
    git github-cli \
    helix neovim vi xclip \
    ranger fzf tree \
    rsync

