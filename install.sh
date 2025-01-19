#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 YYYYMMDDHHMM"
    exit 1
fi

# Get the correct date and time from the input argument
datetime=$1

# Set the correct date and time
sudo date -s "$datetime"

# Wait 30 seconds
sleep 30

# Download the miniforge installer
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/Miniforge3-Linux-x86_64.sh

# Install miniforge to userspace silently
bash /tmp/Miniforge3-Linux-x86_64.sh -b -p $HOME/miniforge3

# Initialize conda
$HOME/miniforge3/bin/conda init

# Install Jupyter Notebook, numpy, scipy, and matplotlib
$HOME/miniforge3/bin/conda install -y jupyter numpy scipy matplotlib

# Install git
sudo apt-get update && sudo apt-get install -y git

# Clone the repository
git clone https://github.com/hariseldon99/msph306 $HOME/msph306

# Remove base environment from bashrc
sed -i '/conda activate base/d' $HOME/.bashrc

# Reload bashrc
source $HOME/.bashrc

echo "Installation complete"
