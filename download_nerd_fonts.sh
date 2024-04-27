#!/bin/bash

# List of fonts to download
declare -a fonts=(
    
    # BitstreamVeraSansMono
    CascadiaCode
    CascadiaMono
    # CodeNewRoman
    # DroidSansMono
    # FiraCode
    # FiraMono
    # Go-Mono
    Hack
    # Hermit
    JetBrainsMono
    # Meslo
    # Noto
    # Overpass
    # ProggyClean
    # RobotoMono
    SourceCodePro
    # SpaceMono
    # Ubuntu
    # UbuntuMono
)

# Nerd Fonts release version
version='3.2.1'

# Directory to download fonts into
# On Debian/Ubuntu
# /usr/local/share/fonts/ to install fonts system-wide
# ~/.local/share/fonts/ or ~/.fonts to install fonts just for the current user
fonts_dir="${HOME}/.local/share/fonts"

# Create the fonts dir if it does not exist
if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

# Do the following for every font in the fonts list
for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    
    # Download the font zip file
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"

    # Unzip the font into the fonts dir and delte the zip file afterwards
    unzip -o "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

# Delete any windows compatible fonts as this script is meant for linux
find "$fonts_dir" -name '*Windows Compatible*' -delete

# Add fonts to cache
fc-cache -fv
