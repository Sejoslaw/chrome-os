echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                    Updating Crostini...                    ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

sudo mv /usr/share/applications/vim.desktop /usr/share/applications/vim.desktop.old
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

echo "" >> /home/$1/.bashrc
echo "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y" >> /home/$1/.bashrc

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                   Setting up utilities...                  ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

sudo apt install --no-install-recommends chromium -y
