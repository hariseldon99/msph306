#!/bin/bash

# Function to set Firefox homepage to Jupyter Notebook URL
set_firefox_homepage() {
    local homepage="http://127.0.0.1:8888"
    local firefox_profile=$(find ~/.mozilla/firefox -name '*.default-release')
    if [ -n "$firefox_profile" ]; then
        echo "user_pref('browser.startup.homepage', '$homepage');" >> "$firefox_profile/user.js"
    else
        echo "Firefox profile not found!"
    fi
}

# Add script to start Jupyter Notebook to autostart
add_autostart() {
    mkdir -p ~/.config/autostart
    cat <<EOL > ~/.config/autostart/start_jupyter.desktop
[Desktop Entry]
Type=Application
Exec=$HOME/start_jupyter.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Start Jupyter Notebook
Name=Start Jupyter Notebook
Comment[en_US]=Start Jupyter Notebook server on login
Comment=Start Jupyter Notebook server on login
EOL
}

# Write the Jupyter start script to home directory
cat <<EOL > ~/start_jupyter.sh
#!/bin/bash
source ~/anaconda3/bin/activate base
jupyter notebook --no-browser --ip=127.0.0.1 --NotebookApp.token='' --NotebookApp.password='' &
EOL

# Make the script executable
chmod +x ~/start_jupyter.sh

# Set Firefox homepage
set_firefox_homepage

# Add the Jupyter start script to autostart
add_autostart

echo "Setup complete. Jupyter Notebook server will start on login and Firefox homepage is set to Jupyter Notebook."
