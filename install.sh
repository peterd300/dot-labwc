cd ~/dot-labwc

sudo xbps-install -Syu

#install open-vmtools-agent for guest in Vmware workstation
sudo xbps-install -Sy open-vm-tools
sudo ln -s /etc/sv/vmware-vmblock-fuse /var/service/
sudo ln -s /etc/sv/vmtoolsd /var/service/


# first install some usefull programs
sudo xbps-install -Sy htop btop make git wget unzip nano cmake curl gcc net-tools fastfetch


# install wayland 
sudo xbps-install -Sy labwc mesa-dri xorg-server-xwayland

# install essiential yprograms
sudo xbps-install -Sy fuzzel Waybar swaybg polkit-gnome xcursor-themes

# install wayland 
sudo xbps-install -Sy foot
mkdir -p ~/.config/foot
cp /etc/xdg/foot/foot.ini ~/.config/foot/foot.ini
echo "font=DejaVu Sans Mono:size=14" >> ~/.config/foot/foot.ini

# install fonts
sudo xbps-install -Sy dejavu-fonts-ttf

sudo xbps-install -Sy dbus
sudo ln -s /etc/sv/dbus /var/service/

sudo xbps-install -Sy elogind
sudo ln -s /etc/sv/elogind /var/service/

sudo xbps-install -Sy seatd
sudo ln -s /etc/sv/seatd /var/service/

#install audio drivers
sudo xbps-install -S pipewire wireplumber



mkdir -p ~/.config/labwc
cp -v /usr/share/doc/labwc/rc.xml.all ~/.config/labwc/rc.xml




mkdir -p ~/.config/labwc
touch ~/.config/labwc/autostart
chmod +x ~/.config/labwc/autostart

cat << EOF > ~/.config/labwc/autostart
#!/bin/sh

# 1. Polkit Authentication Agent (Voor grafische root-rechten, bijv. GParted)
if [ -x /usr/libexec/polkit-gnome-authentication-agent-1 ]; then
    /usr/libexec/polkit-gnome-authentication-agent-1 &
elif [ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ]; then
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
fi

# 2. XDG Desktop Portal (Cruciaal voor schermdelen en flatpaks onder Wayland)
if [ -x /usr/libexec/xdg-desktop-portal ]; then
    /usr/libexec/xdg-desktop-portal &
fi

# 3. Audio & Schermdelen via PipeWire (Zorg dat 'pipewire' geïnstalleerd is)
if command -v pipewire >/dev/null; then
    pipewire &
    wireplumber &
    pipewire-pulse &
fi

# 4. Desktopomgeving componenten (Achtergrond en Statusbalk)
# Pas "background.jpg" aan naar het pad van jouw eigen achtergrondafbeelding
swaybg -i ~/Afbeeldingen/background.jpg -m fill &
waybar &

# 5. Netwerkicoon in het systeemvak (Optioneel, vereist 'network-manager-applet')
nm-applet --indicator &
EOF



# cursor problem in vmware
echo 'WLR_NO_HARDWARE_CURSORS=1'>> ~/.bashrc


# labwc-menu-generator

mkdir ~/src
sudo xbps-install -Sy meson base-devel glib-devel
cd ~/src
git clone https://github.com/labwc/labwc-menu-generator.git
meson compile -C build/
meson setup build/
cd build
sudo meson install

cd ~/dot-labwc
labwc-menu-generator > ~/.config/labwc/menu.xml



#install filemanager + jpg viewer
sudo xbps-install -Sy Thunar thunar-archive-plugin thunar-media-tags-plugin tumbler lximage-qt  

#install X11 icon themes
sudo xbps-install -Sy papirus-icon-theme lxde-icon-theme xcursor-themes

#install geany
sudo xbps-install -Sy geany geany-editorconfig-plugin geany-plugins geany-plugins-extra

# install favorite X11 programs
sudo xbps-install -Sy alacritty kitty 


# install favorite internet browser programs
sudo xbps-install -S firefox


## install x11  fonts
sudo xbps-install -Sy font-awesome adwaita-fonts adwaita-plus
# temporary disabled do to slow download and installation
# sudo xbps-install -Sy nerd-font


# install JetbrainMono Fonts
sudo mkdir -p /usr/local/share/fonts/JetbrainsMono/
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip
unzip JetBrainsMono-2.304.zip -d /tmp/jetbrains-mono
sudo mv /tmp/jetbrains-mono/fonts/* /usr/local/share/fonts/JetbrainsMono/.
fc-cache -f -v
rm ~/dot-labwc/JetBrainsMono-2.304.zip

sudo usermod -Ag _seatd,input,video,audio peter


echo "End of script"
