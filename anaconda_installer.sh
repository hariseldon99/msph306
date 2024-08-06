#!/bin/bash

ANACONDA_INSTALLER="Anaconda3-2024.06-1-Linux-x86_64.sh"
PYVER="python3.12"

# Download the latest Anaconda installer
curl -O https://repo.anaconda.com/archive/$ANACONDA_INSTALLER

# Install Anaconda silently
bash $ANACONDA_INSTALLER -b -p $HOME/anaconda3

# Initialize Anaconda but do not activate on startup
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false

# Create a desktop entry for Anaconda Navigator
cat <<EOF > $HOME/Desktop/Anaconda-Navigator.desktop
[Desktop Entry]
Name=Anaconda Navigator
Comment=Launch Anaconda Navigator
Exec=$HOME/anaconda3/bin/anaconda-navigator
Icon=$HOME/anaconda3/lib/$PYVER/site-packages/anaconda_navigator/static/images/anaconda-icon-256x256.png
Terminal=false
Type=Application
Categories=Development;Education;
EOF

# Make the desktop entry executable
chmod +x $HOME/Desktop/Anaconda-Navigator.desktop

#Copy the repository to Desktop
cp -r ../msph306 $HOME/Desktop
# Make all files read only
chmod -R 544 $HOME/Desktop/msph306

echo "Anaconda installation and desktop icon creation complete!"
