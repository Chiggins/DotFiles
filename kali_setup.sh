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

# SSH
say_stuff "Getting SSH enabled and started"
sudo systemctl enable ssh
sudo systemctl start ssh

# Install Nerd Fonts (FiraCode Nerd Font + Symbols Nerd Font Mono fallback)
say_stuff "Installing Nerd Fonts & Configuring QTerminal"
sudo apt install -y fontconfig unzip curl
sudo mkdir -p /usr/local/share/fonts/NerdFonts
curl -fsSLo /tmp/FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
sudo unzip -oq /tmp/FiraCode.zip -d /usr/local/share/fonts/NerdFonts
curl -fsSLo /tmp/NerdFontsSymbolsOnly.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.zip"
sudo unzip -oq /tmp/NerdFontsSymbolsOnly.zip -d /usr/local/share/fonts/NerdFonts
if [ -f /usr/local/share/fonts/NerdFonts/10-nerd-font-symbols.conf ]; then
  sudo cp -f /usr/local/share/fonts/NerdFonts/10-nerd-font-symbols.conf /etc/fonts/conf.d/10-nerd-font-symbols.conf
fi
rm -f /tmp/FiraCode.zip /tmp/NerdFontsSymbolsOnly.zip
sudo fc-cache -fv

# Set QTerminal to use FiraCode Nerd Font and disable background transparency
if [ -f /etc/xdg/qterminal.org/qterminal.ini ]; then
  sudo sed -i 's/^fontFamily=.*/fontFamily=FiraCode Nerd Font/' /etc/xdg/qterminal.org/qterminal.ini
  sudo sed -i 's/^TerminalTransparency=.*/TerminalTransparency=0/' /etc/xdg/qterminal.org/qterminal.ini
fi
mkdir -p ~/.config/qterminal.org
cat << 'EOF' > ~/.config/qterminal.org/qterminal.ini
[General]
AskOnExit=false
FixedTabWidth=false
TerminalMargin=5
colorScheme=Kali-Dark
fontFamily=FiraCode Nerd Font
fontSize=10
highlightCurrentTerminal=false
HideTabBarWithOneTab=true
HistoryLimited=false
UseFontBoxDrawingChars=true
TerminalTransparency=0
ApplicationTransparency=0

[Shortcuts]
Paste%20Clipboard=Ctrl+Shift+V
EOF

# Disable screen locking, screensaver, and display blanking (always on)
say_stuff "Disabling Screen Lock & Display Blanking"
sudo apt remove -y xfce4-screensaver light-locker 2>/dev/null || true
pkill -f xfce4-screensaver 2>/dev/null || true

# 1. Disable Xorg server-level BlankTime and DPMS
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/10-noblank.conf >/dev/null << 'EOF'
Section "ServerFlags"
    Option "BlankTime"   "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime"     "0"
    Option "DPMS"        "false"
EndSection
EOF

# 2. Disable XFCE Power Manager & Screensaver blanking/locking for current user
mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
cat << 'EOF' > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-power-manager" version="1.0">
  <property name="xfce4-power-manager" type="empty">
    <property name="dpms-enabled" type="bool" value="false"/>
    <property name="blank-on-ac" type="int" value="0"/>
    <property name="dpms-on-ac-sleep" type="uint" value="0"/>
    <property name="dpms-on-ac-off" type="uint" value="0"/>
    <property name="inactivity-on-ac" type="uint" value="0"/>
    <property name="lock-screen-suspend-hibernate" type="bool" value="false"/>
  </property>
</channel>
EOF

cat << 'EOF' > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-screensaver" version="1.0">
  <property name="saver" type="empty">
    <property name="enabled" type="bool" value="false"/>
    <property name="idle-activation" type="empty">
      <property name="enabled" type="bool" value="false"/>
    </property>
  </property>
  <property name="lock" type="empty">
    <property name="enabled" type="bool" value="false"/>
    <property name="saver-activation" type="empty">
      <property name="enabled" type="bool" value="false"/>
    </property>
  </property>
</channel>
EOF

# NeoVim
sudo apt install cmake
git clone https://github.com/neovim/neovim /tmp/neovim
cd /tmp/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo 
sudo make install

# Fin
say_stuff "All done, I recommend a reboot now"
