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
        xterm slim slim-themes archlinux-themes-slim openbox obconf obmenu xmonad xmonad-contrib \
        tint2 trayer network-manager-applet nitrogen screen xmobar transset-df irssi libre-office \
        ctags
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
    rm ~/.zshrc
    ln -s $REPO/zsh/.zshrc ~/.zshrc
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
options=("Install Ubuntu packages" "Install Arch packages" "Setup git submodules" "Setup git" "Setup vim" "Setup ZSH" "Setup RVM" "Setup Openbox" "Setup Xmonad" "Setup general software" "Quit")

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
        "Setup general software")
            v "This will set up all general software (but not installing software)"
            setup_git_submodules
            setup_git
            setup_vim
            setup_zsh
            ;;
        "Quit")
            break
            ;;
        *)
            echo "Invalid Operation";;
    esac
done

