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
echo "##                   Setting up utilities...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##               Setting up 3rd Party Tools...                ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
apt update && apt install brave-browser -y
mv /usr/share/applications/com.brave.Browser.desktop /usr/share/applications/com.brave.Browser.desktop.old

flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub org.gnome.Boxes # /var/lib/flatpak/exports/share/applications/org.gnome.Boxes.desktop <-- "sommelier -X --scale=1.0 --dpi=96"
