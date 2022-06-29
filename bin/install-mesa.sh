#!/usr/bin/bash
# Installs drivers for unsupported NVidia cards.
# Requires paru to work.

paru -S --noconfirm mesa xf86-video-nouveau

