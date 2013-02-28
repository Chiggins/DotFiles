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
    pacman -Syu curl zsh
    v "Finished installing packages..."
    v
}

install_ubuntu_packages() {
    v
    v "install required packages under Ubuntu system..."
    apt-get update
    apt-get upgrade
    apt-get install curl zsh
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
    rm ~/.zshrc
    ln -s $RPO/zsh/.zshrc ~/.zshrc
    v "Done setting up zsh..."
    v
}

options=("Install Ubuntu packages" "Install Arch packages" "Setup git submodules" "Setup vim" "Setup everything" "Quit")

header
select opt in "${options[@]}"
do
    case $opt in 
        "Install Arch packages")
            v "Arch packages"
            install_arch_packages
            ;;
        "Install Ubuntu packages")
            v "Ubuntu packages"
            install_ubuntu_packages
            ;;
        "Setup git submodules")
            ;;
        "Setup vim")
            setup_vim
            ;;
        "Setup everything")
            v "This will set up all software (but not installing software)"
            setup_git_submodules
            setup_vim
            ;;
        "Quit")
            break
            ;;
        *)
            echo "Invalid Operation";;
    esac
done

