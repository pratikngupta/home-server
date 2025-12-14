#!/bin/bash

# Script to add multiple aliases to .zshrc

# --- Configuration ---
# Define the aliases and their target directories
# Format: "alias_name='command_to_run'"
declare -A aliases_to_add
aliases_to_add=(
    ["torrent"]='cd /mnt/movie/data/torrents'
    ["movie"]='cd /mnt/movie/data/media/movies'
    ["code"]='cd /home/pratik/home-server/compose/nvidia'
    ["data"]='cd /home/pratik/appData/data'
    ["music"]='cd /mnt/movie/data/media/music'
    ["dockupr"]='docker compose pull && docker compose up -d --force-recreate'
    ["dockup"]='docker compose pull && docker compose up -d'
)

# Path to the Zsh configuration file
zshrc_file="$HOME/.zshrc"

# --- Main Script ---

echo "Starting to add aliases to $zshrc_file..."

# Add a header for the aliases in .zshrc for better organization if it doesn't exist
header_comment="# Custom Aliases (managed by script)"
if ! grep -qF "$header_comment" "$zshrc_file"; then
    echo -e "\n$header_comment" >> "$zshrc_file"
fi

# Loop through the associative array of aliases
for alias_name in "${!aliases_to_add[@]}"; do
    alias_command="alias $alias_name='${aliases_to_add[$alias_name]}'"
    
    # Check if the alias command (the full line) already exists
    if grep -qF "$alias_command" "$zshrc_file"; then
        echo "Alias for '$alias_name' already exists. Skipping."
    # Check if an alias with the same name but different command exists
    elif grep -qE "alias ${alias_name}=" "$zshrc_file"; then
        echo "Warning: An alias named '$alias_name' but with a different command already exists."
        echo "  Current: $(grep -E "alias ${alias_name}=" "$zshrc_file")"
        echo "  New:     $alias_command"
        echo "Please review your $zshrc_file manually. Skipping this alias to avoid conflicts."
    else
        echo "$alias_command" >> "$zshrc_file"
        echo "Added alias: $alias_name -> '${aliases_to_add[$alias_name]}'"
    fi
done

echo ""
echo "-------------------------------------------------------------------"
echo "Alias processing complete."
echo "To apply the changes, please either:"
echo "1. Source your .zshrc file: source $zshrc_file"
echo "2. Or, open a new Zsh terminal window."
echo "-------------------------------------------------------------------"

# Note: This script only adds aliases.
# If you also wanted to add the environment variable:
# MOVIE_DIR="/mnt/movie/data/media/movies"
# You would add a similar check and append logic for:
# export_command="export MOVIE_DIR=\"/mnt/movie/data/media/movies\""
# if ! grep -qF "\$MOVIE_DIR" "$zshrc_file"; then # Check for the variable name
#     echo "$export_command" >> "$zshrc_file"
#     echo "Added environment variable: MOVIE_DIR"
# else
#     echo "Environment variable MOVIE_DIR seems to exist. Please check manually."
# fi
# For simplicity, this part is commented out but shows how you could extend it.


