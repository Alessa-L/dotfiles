# Install repositories
sudo dnf install -y \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install base groups
sudo dnf group install -y --with-optional \
	virtualization \
	standard \
	hardware-support \
	fonts \
	c-development \
	base-x \
	multimedia

# Install NVIDIA drivers
while true; do
    read -p "Do you wish to install NVIDIA drivers? " yn
    case $yn in
        [Yy]* ) sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Install media codecs
sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade -y --with-optional Multimedia

# Install packages
sudo dnf install -y \
	lightdm-settings \
	slick-greeter \
	light-locker \
	lightdm \
	polkit-gnome \
	gnome-keyring \
	pavucontrol \
	pulseaudio-utils \
	network-manager-applet \
	polybar \
	picom \
	rofi \
	alacritty \
	easyeffects \
	firefox \
	torbrowser-launcher \
	deluge \
	uget \
	eom \
	xfce4-screenshooter \
	nemo \
	nemo-fileroller \
	file-roller \
	celluloid \
	mpv \
	yt-dlp \
	mpd \
	mpc \
	ncmpcpp \
	htop \
	libreoffice-gtk3 \
	libreoffice-writer \
	git \
	papirus-icon-theme \
	openssh-server \
	gparted \
	calibre \
	rust \
	cargo \
	xfce4-session \
	xfce4-settings \
	xfconf \
	xfce4-power-manager \
	xfce4-notifyd \
	zsh \
	zsh-syntax-highlighting \
	zsh-autosuggestions \
	neovim \
	flatpak \
	discord \
	xdg-user-dirs \
	PackageKit-command-not-found

# Install Qtile
sudo dnf install -y \
	python3-pip \
	python3-xcffib \
	python3-cffi \
	python3-cairocffi
pip install qtile

# Install AppImages
wget -P ~/.local/bin/ https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage
wget -P ~/.local/bin/ https://github.com/FreeTubeApp/FreeTube/releases/download/v0.18.0-beta/FreeTube_0.18.0_amd64.AppImage
wget -P ~/.local/bin/ https://github.com/bitwarden/clients/releases/download/desktop-v2023.3.2/Bitwarden-2023.3.2-x86_64.AppImage

# Add flathub and install flatpaks
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y signal

# Install VScode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install -y code

# Install my configurations
git clone https://github.com/Alessa-L/dotfiles
find dotfiles -print0 | xargs -0 mv -t .
sudo cp /home/$USER/Linux/slick-greeter.conf /etc/lightdm/
sudo cp /home/$USER/Media/Images/Wallpaper.jpg /usr/share/backgrounds/

# Disable USB wakeup
sudo cp Linux/disable_usb_wakeup.conf /etc/tmpfiles.d/disable_usb_wakeup.conf

# Set the xfce/qtile session
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa xfsettingsd
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -t string -s qtile -t string -s start
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client2_Command -t string -s picom -t string -s -b
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client3_Command -t string -sa polybar

# Set nemo to use alacritty as its terminal
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

# Change shell to ZSH
chsh -s /bin/zsh
sudo chsh -s /bin/zsh

# Remove unnecessary files from $HOME
ls -a | grep bash | xargs -d "\n" rm
rm -frd .git dotfiles .wget-hsts .lesshst .python_history

sudo systemctl set-default graphical.target
