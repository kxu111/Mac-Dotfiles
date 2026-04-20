#!/bin/bash
INPUT_FILE="$HOME/current-theme.txt"
OUTPUT_FILE="$HOME/.config/ghostty/term-theme.txt"

transformed_name=$(cat "$INPUT_FILE" | sed 's/-/ /g' | sed 's/^/theme = /')
echo "$transformed_name" > "$OUTPUT_FILE"
