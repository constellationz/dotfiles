#!/usr/bin/bash
# Installs everything in order.

SCRIPT_DIR=$(dirname "$0")

# First, install paru and command line programs.
$SCRIPT_DIR/install-paru.sh
$SCRIPT_DIR/install-cli-programs.sh

# Then install mesa and everything involving my desktop environment.
$SCRIPT_DIR/install-mesa.sh
$SCRIPT_DIR/install-awesome.sh
$SCRIPT_DIR/install-gtk-themes.sh

# Finally, install user programs.
$SCRIPT_DIR/install-user-programs.sh
