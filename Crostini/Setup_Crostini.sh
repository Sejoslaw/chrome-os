#!/bin/sh

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##        Welcome to Sejoslaw's Crostini Setup Script         ##"
echo "##                                                            ##"
echo "##  During setup you will be promped for some user-specific   ##"
echo "##  configuration to make the system most optimized for you.  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                 Stable Debian Repositories                 ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

stable_repos="main contrib non-free non-free-firmware"

echo ""
read -p "## Enable stable Debian repositories ($stable_repos)? (yes/empty)" _stableRepos;

if [ "$_stableRepos" != "" ]
then
    sources_list_path="/etc/apt/sources.list"
    cp $sources_list_path "$sources_list_path.backup__old"
    sed -i 's/^/#/' $sources_list_path

    debian_version_codename="$(grep "^VERSION_CODENAME=" /etc/os-release | cut -d'=' -f2)"
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

apt remove vim -y && apt autoremove -y
apt update && apt full-upgrade -y && apt autoremove -y

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                   Setting up utilities...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

install_file_from_url() {
    url_without_file=$1
    file_name=$2

    apt install wget -y
    wget $url_without_file$file_name
    apt install -y ./$file_name
    rm $file_name
}

echo ""
read -p "## Install Google Chrome in Crostini (from official DEB file)? (yes/empty)" _installChrome;

if [ "$_installChrome" != "" ]
then
    install_file_from_url "https://dl.google.com/linux/direct/" "google-chrome-stable_current_amd64.deb"
fi

echo ""
read -p "## Install GNOME Boxes (from Debian repository)? (yes/empty)" _installGnomeBoxes;

if [ "$_installGnomeBoxes" != "" ]
then
    apt install gnome-boxes -y
fi

echo ""
read -p "## Install Steam (from Debian repository)? (yes/empty)" _installSteam;

if [ "$_installSteam" != "" ]
then
    dpkg --add-architecture i386
    apt update
    apt install steam-installer -y

    echo ""
    read -p "## [Steam] Install amd64 libraries (only for AMD graphics)? (yes/empty)" _steamAmdLibs;

    if [ "$_steamAmdLibs" != "" ]
    then
        apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386 -y
    fi
fi

echo ""
read -p "## Install Flatpak? (yes/empty)" _installFlatpak;

if [ "$_installFlatpak" != "" ]
then
    apt install flatpak -y

    echo "## Adding Flathub repo..."
    sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    echo ""
    read -p "## [Flatpak] Install Podman Desktop? (yes/empty)" _flatpakPodmanDesktop;

    if [ "$_flatpakPodmanDesktop" != "" ]
    then
        flatpak install flathub io.podman_desktop.PodmanDesktop
    fi

    echo ""
    read -p "## [Flatpak] Install Bottles? (yes/empty)" _flatpakBottles;

    if [ "$_flatpakBottles" != "" ]
    then
        flatpak install flathub com.usebottles.bottles
    fi

    echo ""
    read -p "## [Flatpak] Install Brave web browser? (yes/empty)" _flatpakBrave;

    if [ "$_flatpakBrave" != "" ]
    then
        flatpak install flathub com.brave.Browser
    fi
fi

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##               Setting up 3rd Party Tools...                ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

echo ""
read -p "## Install AT Launcher for Minecraft (3rd party software)? (yes/empty)" _installATLauncher;

if [ "$_installATLauncher" != "" ]
then
    install_file_from_url "https://download.nodecdn.net/containers/atl/app/dist/linux/" "atlauncher-1.4-1.deb"
fi

echo ""
read -p "## Install VS Code (from Microsoft repository)? (yes/empty)" _installCode;

if [ "$_installCode" != "" ]
then
    apt install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    rm -f packages.microsoft.gpg
    apt install apt-transport-https -y && apt update && apt install code -y
fi

echo ""
read -p "## Install Rust programming language? (yes/empty)" _installRust;

if [ "$_installRust" != "" ]
then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

echo ""
read -p "## Configure JetBrains (IntelliJ, PyCharm, Rider, etc.) unofficial PPA? (yes/empty)" _configureJetBrains;

if [ "$_configureJetBrains" != "" ]
then
    curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
    sudo apt update
fi

echo ""
read -p "## Install Rancher Desktop (local Kubernetes cluster)? (yes/empty)" _installRancherDekstop;

if [ "$_installRancherDekstop" != "" ]
then
    curl -s https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/Release.key | gpg --dearmor | sudo dd status=none of=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg
    echo 'deb [signed-by=/usr/share/keyrings/isv-rancher-stable-archive-keyring.gpg] https://download.opensuse.org/repositories/isv:/Rancher:/stable/deb/ ./' | sudo dd status=none of=/etc/apt/sources.list.d/isv-rancher-stable.list
    sudo apt update
    sudo apt install rancher-desktop -y
fi

echo ""
read -p "## Install kubectl (official website)? (yes/empty)" _installKubectl;

if [ "$_installKubectl" != "" ]
then
    sudo apt install -y apt-transport-https ca-certificates curl gnupg
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install kubectl -y
fi
