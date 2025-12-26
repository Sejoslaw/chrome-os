echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                    Updating Crostini...                    ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

mv /usr/share/applications/vim.desktop /usr/share/applications/vim.desktop.old
apt update && apt full-upgrade -y && apt autoremove -y

echo "" >> /home/$1/.bashrc
echo "alias update-crostini='sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && flatpak update'" >> /home/$1/.bashrc

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                   Setting up utilities...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

apt install podman -y

if ! grep -q "$1" /etc/subuid; then
    echo "$1:100000:65536" | sudo tee -a /etc/subuid
    echo "$1:100000:65536" | sudo tee -a /etc/subgid
fi

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                    Setting up Flatpaks...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

apt install flatpak -y

sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub com.brave.Browser
flatpak install -y flathub com.valvesoftware.Steam
flatpak install -y flathub com.atlauncher.ATLauncher

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                  Setting up Containers...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

sh ./chrome-os/Crostini/Setup_Crostini_Podman_Containers.sh
