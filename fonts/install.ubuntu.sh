#!/bin/bash
#
# Install fonts for Ubuntu

# Clean tmp folder
rm -rf $DOTFILES/fonts/tmp

# Download fonts
echo 'Downloading fonts'
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -P $DOTFILES/fonts/tmp -q

# Extract fonts
echo 'Extracting fonts'
unzip -q $DOTFILES/fonts/tmp/JetBrainsMono.zip -d $DOTFILES/fonts/tmp/JetBrainsMono

# Copy fonts
mkdir -p $DOTFILES/fonts/.fonts
cp $DOTFILES/fonts/tmp/JetBrainsMono/JetBrainsMonoNerdFontMono-Regular.ttf $DOTFILES/fonts/.fonts/

# Clean tmp folder
rm -rf $DOTFILES/fonts/tmp

echo "Installed fonts"
