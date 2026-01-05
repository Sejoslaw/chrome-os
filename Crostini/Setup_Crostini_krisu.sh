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

apt install podman -y

if ! grep -q "$1" /etc/subuid; then
    echo "$1:100000:65536" | sudo tee -a /etc/subuid
    echo "$1:100000:65536" | sudo tee -a /etc/subgid
fi
