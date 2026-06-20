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
