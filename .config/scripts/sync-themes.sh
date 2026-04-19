#!/bin/bash
THEME_NAME_FILE="$HOME/.local/share/nvim/selected_theme.txt"
OUTPUT_FILE="$HOME/.config/ghostty/ghostty-theme.txt"

transformed_name=$(cat "$THEME_NAME_FILE" | sed 's/-/ /g' | sed 's/^/theme = /')
echo "$transformed_name" > "$OUTPUT_FILE"
