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

echo ""
echo "################################################################"
echo "##                                                            ##"
echo "##               Setting up 3rd Party Tools...                ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "" >> /home/$USER/.bashrc
echo "sudo flatpak update -y" >> /home/$USER/.bashrc

sudo flatpak install -y flathub \
  com.github.tchx84.Flatseal \
  org.virt_manager.virt-manager \
  org.virt_manager.virt_manager.Extension.Qemu

flatpak override org.virt_manager.virt-manager \
  --user \
  --unshare=ipc \
  --nosocket=x11 \
  --nosocket=fallback-x11 \
  --nosocket=ssh-auth \
  --nodevice=all \
  --device=kvm \
  --filesystem=/home/$USER/Downloads \
  --nofilesystem=~/.ssh \
  --nofilesystem=xdg-documents \
  --nofilesystem=xdg-run/libvirt \
  --nofilesystem=xdg-download \
  --nofilesystem=xdg-videos \
  --nofilesystem=/run/libvirt \
  --nofilesystem=xdg-public-share \
  --nofilesystem=xdg-pictures \
  --nofilesystem=xdg-music \
  --no-talk-name=org.freedesktop.secrets \
  --no-talk-name=org.kde.StatusNotifierWatcher

echo '' >> /home/$USER/.bashrc

echo 'alias virsh="flatpak run --command=virsh org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$USER/.bashrc

echo 'alias virt-admin="flatpak run --command=virt-admin org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$USER/.bashrc
echo 'alias virt-clone="flatpak run --command=virt-clone org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$USER/.bashrc
echo 'alias virt-install="flatpak run --command=virt-install org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$USER/.bashrc
echo 'alias virt-manager="flatpak run org.virt_manager.virt-manager"' >> /home/$USER/.bashrc
echo 'alias virt-xml="flatpak run --command=virt-xml org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$USER/.bashrc
echo 'alias virt-xml-validate="flatpak run --command=virt-xml-validate org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$USER/.bashrc

echo 'alias qemu-img="flatpak run --command=qemu-img org.virt_manager.virt-manager"' >> /home/$USER/.bashrc
echo 'alias qemu-io="flatpak run --command=qemu-io org.virt_manager.virt-manager"' >> /home/$USER/.bashrc
echo 'alias qemu-keymap="flatpak run --command=qemu-keymap org.virt_manager.virt-manager"' >> /home/$USER/.bashrc

echo 'alias qemu-system-aarch64="flatpak run --command=qemu-system-aarch64 org.virt_manager.virt-manager"' >> /home/$USER/.bashrc
echo 'alias qemu-system-arm="flatpak run --command=qemu-system-arm org.virt_manager.virt-manager"' >> /home/$USER/.bashrc
echo 'alias qemu-system-i386="flatpak run --command=qemu-system-i386 org.virt_manager.virt-manager"' >> /home/$USER/.bashrc
echo 'alias qemu-system-x86_64="flatpak run --command=qemu-system-x86_64 org.virt_manager.virt-manager"' >> /home/$USER/.bashrc

source /home/$USER/.bashrc
