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
echo "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y" >> /home/$1/.bashrc

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                   Setting up utilities...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

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
