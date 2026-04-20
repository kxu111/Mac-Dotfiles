#!/bin/bash
current_theme=$(cat $HOME/current-theme.txt)

if [ "$current_theme" = "vague" ]; then
    desktoppr "$HOME/Pictures/walls/sunflower.jpg"
fi
if [ "$current_theme" = "Black Metal (Khold)" ]; then
    desktoppr "$HOME/Pictures/walls/ultrakill.png"
fi
if [ "$current_theme" = "oxocarbon" ]; then
    desktoppr "$HOME/Pictures/walls/mushrooms.jpg"
fi
