#!/bin/bash

# Colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NO_COLOR='\033[0m'

WORK_DIR=$HOME/RP5_Lite_Env

# $1 - prompt string
# $2 - NO selection string
# $3 - YES selection function
function prompt() {
    while true; do
        # prompting for choice
        read -p "$1 (y)es/(n)o/(c)ancel:- " choice

        # giving choices there tasks using
        case $choice in
        [yY]* ) $3; break;;
        [nN]* ) echo -e "${YELLOW}${2}${NO_COLOR}"; break;;
        [cC]* ) echo -e "${RED}Installation cancelled${NO_COLOR}"; exit ;;
        *) echo "input is not valid!" ;;
        esac
    done
}

function init_installs() {
    echo -e "${GREEN}Updating and Upgrading apt, then installing initial packages${NO_COLOR}"

    # Update apt repositories
    sudo apt-get update

    # Upgrade existing packages
    sudo apt-get -y upgrade

    # Install important packages
    sudo apt-get -y install git cmake build-essential dpkg xdg-user-dirs p7zip-full

    # Create user directories
    xdg-user-dirs-update
}


function install_i3() {
    echo -e "${GREEN}Installing the i3 desktop environment including lightdm greeter${NO_COLOR}"

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


function install_neovim() {
    echo -e "${GREEN}Installing the latest version of Neovim${NO_COLOR}"

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
    sudo rm -Rf neovim
}

function install_pico_sdk() {
    echo -e "${GREEN}Installing the Raspberry Pico SDK and Examples${NO_COLOR}"

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

function configure_sakura() {
    echo -e "${GREEN}Configuring the Sakura terminal emulator, includs downloading and installing some Nerd Fonts${NO_COLOR}"

    # Download and install fonts using external script
    ORIG_DIR=`pwd`
    cd $WORK_DIR
    ./download_nerd_fonts.sh

    # Copy neovim config files
    cp -r $WORK_DIR/sakura_config/* $HOME/.config

    # Go back to original directory
    cd $ORIG_DIR
}

function configure_ranger() {
    echo -e "${GREEN}Configuring the Ranger file browser${NO_COLOR}"
 
    # Copy neovim config files
    cp -r $WORK_DIR/ranger_config/* $HOME/.config
}


cd ~

prompt "Do you want to install initial packages?" "Skipping init installations" init_installs
prompt "Do you want to install the i3 desktop environment?" "Skipping i3 environment installation" install_i3
prompt "Do you want to install neovim?" "Skipping neovim installation" install_neovim
prompt "Do you want to install raspberry pi pico sdk?" "Skipping pico SDK installation" install_pico_sdk
prompt "Do you want to configure sakura?" "Skipping sakura configuration" configure_sakura
prompt "Do you want to configure ranger?" "Skipping ranger configuration" configure_ranger

