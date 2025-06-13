#!/bin/bash

# Create fonts directory if it doesn't exist
mkdir -p assets/fonts

# Download PressStart2P font
curl -L "https://fonts.google.com/download?family=Press+Start+2P" -o press_start_2p.zip

# Unzip the font file
unzip press_start_2p.zip -d temp_fonts

# Move the font file to the assets directory
mv temp_fonts/static/PressStart2P-Regular.ttf assets/fonts/

# Clean up
rm -rf temp_fonts press_start_2p.zip 