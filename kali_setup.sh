#!/bin/bash

say_stuff () {
  echo "======================="
  echo $1
  echo "======================="
}

# Make sure we have apt up to date
say_stuff "Apt updating"
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
sudo apt update

# Set up /opt/tools/
say_stuff "Creating /opt/tools/"
if [ ! -d /opt/tools/ ]; then
  sudo mkdir /opt/tools/
  sudo chown kali:kali /opt/tools/
fi

# Pipx setup
say_stuff "Installing Pipx"
sudo apt install -y pipx git
pipx ensurepath

# Set up Docker
say_stuff "Installing Docker"
sudo apt install -y docker.io
sudo systemctl enable docker --now
sudo usermod -aG docker kali

# NetExec
say_stuff "Installing NetExec"
pipx install git+https://github.com/Pennyw0rth/NetExec

# BloodHound
say_stuff "Installing BloodHound"
sudo apt install -y bloodhound
echo "Run 'sudo neo4j console', and change default credentials of neo4j:neo4j"
echo "Then run 'bloodhound' to open GUI"

# bbot
say_stuff "Installing bbot"
pipx install bbot

# Certipy
say_stuff "Installing Certipy"
pipx install certipy-ad

# Coercer
say_stuff "Installing Coercer"
pipx install coercer

# ADExplorerSnapshot.py
say_stuff "Installing ADExplorerSnapshot.py"
git clone https://github.com/c3c/ADExplorerSnapshot.py.git /opt/tools/ADExplorerSnapshot.py/
cd /opt/tools/ADExplorerSnapshot.py/
pipx install .
cd -

# BloodHound.py
say_stuff "Installing BloodHound.py"
pipx install bloodhound

# PetitPotam
say_stuff "Installing PetitPotam"
git clone https://github.com/topotam/PetitPotam /opt/tools/PetitPotam/

# Pywerview
say_stuff "Installing Pywerview"
pipx install pywerview

# CredNinja
say_stuff "Installing CredNinja"
git clone https://github.com/raikia/CredNinja.git /opt/tools/CredNinja/
