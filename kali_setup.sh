#!/bin/bash

say_stuff () {
  echo "======================="
  echo $1
  echo "======================="
}

get_git () {
  toolname=`echo $1 | cut -d '/' -f 5`
  echo "Cloning ${toolname}"
  if [ ! -d "/opt/tools/${toolname}" ]; then
    git clone $1 "/opt/tools/${toolname}"
  fi
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
get_git https://github.com/c3c/ADExplorerSnapshot.py
cd /opt/tools/ADExplorerSnapshot.py/
pipx install .
cd -

# BloodHound.py
say_stuff "Installing BloodHound.py"
pipx install bloodhound

# PetitPotam
say_stuff "Installing PetitPotam"
get_git https://github.com/topotam/PetitPotam

# Pywerview
say_stuff "Installing Pywerview"
pipx install pywerview

# CredNinja
say_stuff "Installing CredNinja"
get_git https://github.com/raikia/CredNinja.git

# PyMeta
say_stuff "Installing PyMeta"
sudo apt install exiftool -y
pipx install pymetasec

# Metagoofil
say_stuff "Installing MetaGooFil"
sudo apt install metagoofil -y

# SMBCrunch
say_stuff "Installing SMBCrunch"
get_git https://github.com/Raikia/SMBCrunch

# PXEThief
say_stuff "Installing PXEThief"
get_git https://github.com/MWR-CyberSec/PXEThief

# SCCMHunter
say_stuff "Installing SCCMHunter"
pipx install git+https://github.com/garrettfoster13/sccmhunter/

# ldeep
say_stuff "Installing ldeep"
python -m pip install git+https://github.com/franc-pentest/ldeep

# pyldapsearch
say_stuff "Installing pyldapsearch"
pipx install git+https://github.com/Tw1sm/pyldapsearch

# BOFHound
say_stuff "Installing BOFHound"
pipx install git+https://github.com/coffeegist/bofhound

# DonPAPI
say_stuff "Installing DonPAPI"
sudo apt install libxslt1-dev libxml2-dev -y
pipx install donpapi

# lsassy
say_stuff "Installing lsassy"
pipx install lsassy
