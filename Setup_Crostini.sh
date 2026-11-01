echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                        Updating...                         ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

sudo mv /usr/share/applications/vim.desktop /usr/share/applications/vim.desktop.old
sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y

echo "" >> /home/$USER/.bashrc
echo "sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y" >> /home/$USER/.bashrc

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##                       Setting up...                        ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

#Google Chrome
curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb -y

# Brave Browser
curl -fsS https://dl.brave.com/install.sh | sh
