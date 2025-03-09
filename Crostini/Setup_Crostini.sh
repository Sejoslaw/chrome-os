#!/bin/sh

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                 Stable Debian Repositories                 ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

stable_repos="main contrib non-free non-free-firmware"

echo ""
read "## Enable stable Debian repositories ($stable_repos)? (yes/empty)" _stableRepos;

if [ "$_stableRepos" != "" ]
then
    sources_list_path="/etc/apt/sources.list"
    cp $sources_list_path "$sources_list_path.backup__old"
    sed -i 's/^/#/' $sources_list_path

    debian_version_codename=(grep "^VERSION_CODENAME=" /etc/os-release | cut -d'=' -f2)
    echo "" >> $sources_list_path
    echo "# Generated by Sejoslaw's Setup Crostini Script" >> $sources_list_path
    echo "deb http://deb.debian.org/debian $debian_version_codename $stable_repos" >> $sources_list_path
    echo "deb http://deb.debian.org/debian $debian_version_codename-updates $stable_repos" >> $sources_list_path
    echo "deb http://deb.debian.org/debian-security $debian_version_codename-security $stable_repos" >> $sources_list_path
fi

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                    Updating Crostini...                    ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

apt update && apt dist-upgrade -y && apt autoremove -y

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                   Setting up utilities...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

echo ""
read -p "## Install Google Chrome in Crostini (from official DEB file)? (yes/empty)" _installChrome;

if [ "$_installChrome" != "" ]
then
    file_name=google-chrome-stable_current_amd64.deb

    apt install wget
    wget https://dl.google.com/linux/direct/$file_name
    apt install -y ./$file_name
    rm $file_name
fi

echo ""
read -p "## Install GNOME Boxes (from Debian repository)? (yes/empty)" _installGnomeBoxes;

if [ "$_installGnomeBoxes" != "" ]
then
    apt install gnome-boxes
fi

echo ""
read -p "## Install Steam (from Debian repository)? (yes/empty)" _installSteam;

if [ "$_installSteam" != "" ]
then
    dpkg --add-architecture i386
    apt update
    apt install steam-installer
fi

echo ""
read -p "## Install Flatpak? (yes/empty)" _installFlatpak;

if [ "$_installFlatpak" != "" ]
then
    apt install flatpak

    echo "## Adding Flathub repo..."
    flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi
