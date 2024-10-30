#!/bin/bash

ANACONDA_INST_DIR="./anaconda_installer"
PYVER="python3.12"
REPONAME="msph306"
DESK_ICO="$HOME/Anaconda-Navigator.desktop"
ANACONDA_INSTALLER_NAME="Anaconda3-2024.10-1-Linux-x86_64.sh"

# Function to create desktop entry
create_desktop_entry() {
    cat <<EOF > "$DESK_ICO"
[Desktop Entry]
Name=Anaconda Navigator
Comment=Launch Anaconda Navigator
Exec=$HOME/anaconda3/bin/anaconda-navigator
Icon=$HOME/anaconda3/lib/$PYVER/site-packages/anaconda_navigator/static/images/anaconda-icon-256x256.png
Terminal=false
Type=Application
Categories=Development;Education;
EOF
    gio set "$DESK_ICO" metadata::trusted true
    chmod +x "$DESK_ICO"
}

# Main script execution
echo "Starting ${ANACONDA_INSTALLER_NAME} Installation"
bash "${ANACONDA_INST_DIR}/${ANACONDA_INSTALLER_NAME}" -b -p "$HOME/anaconda3"
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false

echo "Creating Desktop icon @ ${DESK_ICO} and copying MSPH306 git repo to ${HOME}"
create_desktop_entry

mkdir "$HOME/$REPONAME"
chmod -R 544 $HOME/$REPONAME
chmod -R 544 $HOME/anaconda3
chmod -R 544 $DESK_ICO
rsync -vra --exclude="${ANACONDA_INSTALLER_NAME}" --progress ./ "$HOME/$REPONAME"

echo "Installation and desktop icon creation complete!"
