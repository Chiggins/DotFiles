#!/bin/bash
PS3='Please enter your choice: '
REPO=$(pwd)
TXTRED=$(tput setaf 1)
TXTYEL=$(tput setaf 3)
TXTRST=$(tput sgr0)
v(){
    echo "[${TXTYEL}*${TXTRST}] ${TXTYEL}$1${TXTRST}"
}

header() {
    v
    v
    v "Chiggins system bootstrap script"
    v "Install and configure ALL THE THINGS"
    v "Account password might be asked from"
    v "    time to time"
    v
    v
}

install_arch_packages() {
    v
    v "Installing required packages under Arch Linux system..."
    sudo pacman -Syu --noconfirm curl zsh alsa-utils openssh expac vim xorg-server xorg-xinit \
        xorg-server-utils xf86-video-vesa lib32-nvidia-utils ttf-dejavu xorg-twm xorg-xclock \
        xterm slim slim-themes archlinux-themes-slim screen irssi libreoffice wget yajl\
        ctags chromium firefox thunderbird fakeroot hsetroot gmrun wireshark
    sudo systemctl enable sshd.service
    sudo systemctl enable slim.service
    sudo ln -s $REPO/slim/slim.conf /etc/
    # bspwm sxhkd bar stlarch_font stlarch_icons
    v "Finished installing packages..."
    v
}

install_arch_headless_packages() {
    v
    v "Installing required packages under Arch Linux system (headless)..."
    sudo pacman -Syu --noconfirm curl zsh openssh vim screen irssi ctags python2 python2-pip \
        python python-pip libffi libyaml openssl fakeroot
    sudo systemctl enable sshd.service
    sudo systemctl enable slim.service
    sudo ln -s $REPO/slim/slim.conf /etc/
    v "Finished installing packages..."
    v
}

install_ubuntu_packages() {
    v
    v "install required packages under Ubuntu system..."
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl zsh
    v "Finished installing packages..."
    v
}

install_kali_packages() {
    v
    v "Install required packages under Kali system..."
    apt-get update
    apt-get upgrade -y
    apt-get install -y curl zsh xmonad xmobar xterm trayer
    v "Finished installing packages..."
    v
}

setup_git_submodules() {
    v
    v "Setting up all git submodules..."
    git submodule init
    git submodule update
    v "Done setting up all git submodules..."
    v
}

setup_git() {
    v
    v "Setting up git..."
    rm ~/.gitconfig
    ln -s $REPO/git/.gitconfig ~
    v "Done setting up git..."
    v
}

setup_vim() {
    v
    v "Setting up vim..."
    echo "runtime vimrc" > ~/.vimrc
    ln -s $REPO/vim ~/.vim
    v "Done setting up vim"
    v
}

setup_zsh() {
    v
    v "Setting up zsh..."
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
    if [-d ~/.zshrc]
    then
        rm ~/.zshrc
    fi
    ln -s $REPO/zsh/.zshrc ~/.zshrc
    ln -s $REPO/zsh/chiggins.zsh-theme ~/.oh-my-zsh/themes/chiggins.zsh-theme
    v "Done setting up zsh..."
    v
}

setup_rvm() {
    v
    v "Setting up RVM..."
    curl -L https://get.rvm.io | bash -s stable --ruby
    v "Done setting up RVM..."
    v
}

setup_openbox() {
    v
    v "Setting up Openbox..."
    if [ ! -d ~/.config/ ]; then
        mkdir ~/.config
    fi
    ln -s $REPO/desktop/openbox ~/.config/openbox
    v "Done setting up Openbox..."
    v
}

setup_xmonad() {
    v
    v "Setting up Xmonad..."
    ln -s $REPO/laptop/xmonad ~/.xmonad
    ln -s $REPO/laptop/xmobar/xmobarrc ~/.xmobarrc
    v "Done setting up Xmonad..."
    v
}

setup_irssi() {
    v
    v "Setting up irssi..."
    ln -s $REPO/irssi ~/.irssi
    v "Done setting up irssi..."
    v
}
options=("Install Ubuntu packages" "Install Kali packages" "Install Arch packages" "Install Arch headless packages" "Setup git submodules" "Setup git" "Setup vim" "Setup ZSH" "Setup RVM" "Setup Openbox" "Setup Xmonad" "Setup irssi" "Setup general software" "Quit")

header
select opt in "${options[@]}"
do
    case $opt in 
        "Install Arch packages")
            v "Arch packages"
            install_arch_packages
            ;;
        "Install Arch headless packages")
            v "Arch (headless) packages"
            install_arch_headless_packages
            ;;
        "Install Ubuntu packages")
            v "Ubuntu packages"
            install_ubuntu_packages
            ;;
	"Install Kali packages")
            v "Kali packages"
	    install_kali_packages
            ;;
        "Setup git submodules")
            setup_git_submodules
            ;;
        "Setup git")
            setup_git
            ;;
        "Setup vim")
            setup_vim
            ;;
        "Setup ZSH")
            setup_zsh
            ;;
        "Setup RVM")
            setup_rvm
            ;;
        "Setup Openbox")
            setup_openbox
            ;;
        "Setup Xmonad")
            setup_xmonad
            ;;
        "Setup irssi")
            setup_irssi
            ;;
        "Setup general software")
            v "This will set up all general software (but not installing software)"
            setup_git_submodules
            setup_git
            setup_vim
            setup_zsh
            setup_irssi
            ;;
        "Quit")
            break
            ;;
        *)
            echo "Invalid Operation";;
    esac
done

