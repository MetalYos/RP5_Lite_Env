#!/bin/bash

WORK_DIR=$HOME/RP5_Lite_Env

function init_installs() {
    # Update apt repositories
    sudo apt-get update

    # Upgrade existing packages
    sudo apt-get -y upgrade

    # Install important packages
    sudo apt-get -y install git cmake build-essential dpkg xdg-user-dirs p7zip-full

    # Create user directories
    xdg-user-dirs-update
}

function init_installs_prompt() {
    while true; do
        # prompting for choice
        read -p "Do you want to install initial packages? (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) init_installs; break;;
        [nN]* ) echo "Skipping init installations"; break;;
        [cC]* ) echo "Installation cancelled"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}

function install_i3() {
    # Install X11
    sudo apt-get -y install xorg xclip

    # Install LightDM
    sudo apt-get -y install lightdm lightdm-gtk-greeter

    # TODO: update greeter-session in lightdm.conf file to use lightdm-gtk-greeter, using the sed command

    # Enable lightdm service
    sudo systemctl enable lightdm.service
    sudo systemctl set-default graphical.target

    # Install i3
    sudo apt-get -y install i3 dmenu suckless-tools

    # Install applications that are used in i3 config
    sudo apt-get -y install sakura firefox ranger thunderbird copyq feh xarchiver

    # Copy i3 config files
    cp -r $WORK_DIR/i3_config/* $HOME/.config

    # Copy Pictures
    cp -r $WORK_DIR/Pictures/* $HOME/Pictures
}

function install_i3_prompt() {
    while true; do
        # prompting for choice
        read -p "Do you want to install the i3 desktop environment? (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) install_i3; break;;
        [nN]* ) echo "Skipping i3 environment installation"; break;;
        [cC]* ) echo "Installation cancelled"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}

function install_neovim() {
    #Install packages needed for neovim
    sudo apt-get -y install git cmake build-essential gettext npm ripgrep fd-find fswatch 

    # Clone neovim repository to get latest version
    git clone https://github.com/neovim/neovim
    cd neovim
    
    # Build neovim
    make CMAKE_BUILD_TYPE=Release

    # Create a debian package and install it
    cd build
    sudo cpack -G DEB
    sudo dpkg -i nvim-linux64.deb

    # Copy neovim config files
    cp -r $WORK_DIR/nvim_config/* $HOME/.config

    # Get back to starting directory
    cd ..
    cd ..
    
    # Remove the neovim folder that was cloned
    rm -Rf neovim
}

function install_neovim_prompt() {
    while true; do
        # prompting for choice
        read -p "Do you want to install neovim? (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) install_neovim; break;;
        [nN]* ) echo "Skipping neovim installation"; break;;
        [cC]* ) echo "Installation cancelled"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}

function install_pico_sdk() {
    # Install packages need to build pico projects
    sudo apt-get -y install git cmake gcc-arm-none-eabi libnewlib-arm-none-eabi build-essential openocd gdb-multiarch screen

    cd $HOME
    mkdir pico
    cd pico

    git clone https://github.com/raspberrypi/pico-sdk.git --branch master
    cd pico-sdk
    git submodule update --init
    cd ..
    git clone https://github.com/raspberrypi/pico-examples.git --branch master

    echo >> $HOME/.bashrc
    echo '# Add pico SDK folder to environment variables' >> $HOME/.bashrc
    echo 'export PICO_SDK_PATH=$HOME/pico/pico-sdk' >> $HOME/.bashrc
}

function install_pico_sdk_prompt() {
    while true; do
        # prompting for choice
        read -p "Do you want to install raspberry pi pico sdk? (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) install_pico_sdk; break;;
        [nN]* ) echo "Skipping pico SDK installation"; break;;
        [cC]* ) echo "Installation cancelled"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}

function configure_sakura() {
    # Download and install fonts using external script
    ORIG_DIR=`pwd`
    cd $HOME/RPI5_Init
    ./download_nerd_fonts.sh

    # Copy neovim config files
    cp -r $WORK_DIR/sakura_config/* $HOME/.config

    # Go back to original directory
    cd $ORIG_DIR
}

function configure_sakura_prompt() {
    while true; do
        # prompting for choice
        read -p "Do you want to configure sakura? (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) configure_sakura; break;;
        [nN]* ) echo "Skipping sakura configuration"; break;;
        [cC]* ) echo "Installation cancelled"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}

function configure_ranger() {
    # Unzip config files
 
    # Copy neovim config files
    cp -r $WORK_DIR/ranger_config/* $HOME/.config
}

function configure_ranger_prompt() {
    while true; do
        # prompting for choice
        read -p "Do you want to configure ranger? (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) configure_ranger; break;;
        [nN]* ) echo "Skipping ranger configuration"; break;;
        [cC]* ) echo "Installation cancelled"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}


cd ~

init_installs_prompt
install_i3_prompt
install_neovim_prompt
install_pico_sdk_prompt
configure_sakura_prompt
configure_ranger_prompt

