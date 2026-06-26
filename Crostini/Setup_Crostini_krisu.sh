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
echo "##               Setting up 3rd Party Tools...                ##"
echo "##                                                            ##"
echo "################################################################"
echo ""

sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "" >> /home/$1/.bashrc
echo "sudo flatpak update" >> /home/$1/.bashrc

sudo flatpak install -y flathub \
  com.github.tchx84.Flatseal \
  com.brave.Browser

flatpak override com.brave.Browser \
  --user \
  --nosocket=pcsc \
  --nosocket=cups \
  --nodevice=all \
  --device=dri \
  --disallow=bluetooth \
  --nofilesystem=host-etc \
  --filesystem=/home/$1/Downloads \
  --nofilesystem=xdg-desktop \
  --nofilesystem=xdg-run/pipewire-0 \
  --nofilesystem=xdg-run/dconf \
  --nofilesystem=xdg-download \
  --nofilesystem=~/.local/share/icons \
  --nofilesystem=~/.config/dconf \
  --nofilesystem=/run/.heim_org.h5l.kcm-socket \
  --nofilesystem=~/.local/share/applications \
  --nofilesystem=/tmp \
  --nofilesystem=~/.config/kioslaverc \
  --system-no-talk-name=org.bluez \
  --system-no-talk-name=org.freedesktop.UPower \
  --system-no-talk-name=org.freedesktop.Avahi \
  --no-talk-name=org.gnome.ScreenSaver \
  --no-talk-name=org.kde.kwalletd6 \
  --no-talk-name=org.gnome.SessionManager \
  --no-talk-name=com.canonical.AppMenu.Registrar \
  --no-talk-name=ca.desrt.dconf \
  --no-talk-name=org.freedesktop.secrets \
  --no-talk-name=org.cinnamon.ScreenSaver \
  --no-talk-name=org.freedesktop.ScreenSaver \
  --no-talk-name=org.gnome.Mutter.IdleMonitor.* \
  --no-talk-name=org.xfce.ScreenSaver \
  --no-talk-name=org.mate.ScreenSaver \
  --no-talk-name=org.kde.kwalletd5 \
  --no-talk-name=org.freedesktop.FileManager1 \
  --no-talk-name=org.freedesktop.Notifications

sudo flatpak install -y flathub \
  org.virt_manager.virt-manager \
  org.virt_manager.virt_manager.Extension.Qemu

flatpak override org.virt_manager.virt-manager \
  --user \
  --nodevice=all \
  --device=kvm \
  --filesystem=/home/$1/Downloads \
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

echo '' >> /home/$1/.bashrc
echo 'alias virsh="flatpak run org.virt_manager.virt-manager --connect qemu:///session --command=virsh"' >> /home/$1/.bashrc
echo 'alias virt-install="flatpak run org.virt_manager.virt-manager --connect qemu:///session --command=virt-install"' >> /home/$1/.bashrc
echo 'alias virt-clone="flatpak run org.virt_manager.virt-manager --connect qemu:///session --command=virt-clone"' >> /home/$1/.bashrc
echo 'alias virt-manager="flatpak run org.virt_manager.virt-manager --connect qemu:///session"' >> /home/$1/.bashrc

source /home/$1/.bashrc
