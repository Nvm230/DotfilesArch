#!/bin/bash

# Check if a wallpaper is already cached by pywal
if [ -f "$HOME/.cache/wal/wal" ]; then
    # Read the current wallpaper path
    current_wall=$(cat "$HOME/.cache/wal/wal")
    
    # Apply it without transition (restore state)
    swww img "$current_wall" --transition-type none
    wal -i "$current_wall" -n
else
    # No cache found, pick a random one
    image_path=$(find ~/.wallpapers/ -type f | shuf -n1)
    swww img "$image_path" --transition-type none
    wal -i "$image_path" -n
fi
