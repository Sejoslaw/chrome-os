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
echo "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo flatpak update" >> /home/$1/.bashrc

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
flatpak install -y flathub org.gnome.Boxes # /var/lib/flatpak/exports/share/applications/org.gnome.Boxes.desktop <-- "sommelier -X --scale=1.0 --dpi=96"
