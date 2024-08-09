#!/bin/bash

ANACONDA_INST_DIR="./anaconda_installer"
PYVER="python3.12"
REPONAME="msph306"
DESK_ICO="$HOME/Desktop/Anaconda-Navigator.desktop"

# Function to check for internet and set installer name
set_installer_name() {
    if wget -q --spider http://google.com; then
        echo "Online"
        LATEST_VERSION=$(curl --silent https://repo.anaconda.com/archive/ | grep -o 'href=".*sh">' | sed 's/href="//;s/\/">//' | awk -F- '{print $2"-"$3}' | sort -n | tail -n 1)
        ANACONDA_INSTALLER_NAME="Anaconda3-${LATEST_VERSION}-Linux-x86_64.sh"
    else
        echo "Offline"
        ANACONDA_INSTALLER_NAME="Anaconda3-2024.06-1-Linux-x86_64.sh"
    fi
}

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
set_installer_name
echo "Starting ${ANACONDA_INSTALLER_NAME} Installation"

if ! test -f "$ANACONDA_INST_DIR/$ANACONDA_INSTALLER_NAME"; then 
    mkdir -p "$ANACONDA_INST_DIR"
    curl -o "$ANACONDA_INST_DIR/$ANACONDA_INSTALLER_NAME" -O "https://repo.anaconda.com/archive/$ANACONDA_INSTALLER_NAME"
fi

bash "$ANACONDA_INST_DIR/$ANACONDA_INSTALLER_NAME" -b -p "$HOME/anaconda3"
eval "$($HOME/anaconda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false

echo "Creating Desktop icon @ ${DESK_ICO} and copying MSPH306 git repo to ${HOME}"
create_desktop_entry

mkdir "$HOME/$REPONAME"
rsync -vra --exclude="${ANACONDA_INSTALLER_NAME}" --progress ./ "$HOME/$REPONAME"
chmod -R 544 "$HOME/$REPONAME"

echo "Installation and desktop icon creation complete!"
