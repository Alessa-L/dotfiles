# Install repositories
sudo dnf install -y \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install base groups
sudo dnf group install -y --with-optional \
	virtualization \
	standard \
	hardware-support \
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
	libreoffice-langpack-pt-BR \
	libreoffice-writer \
	git \
	papirus-icon-theme \
	openssh-server \
	gparted \
	calibre \
	xfce4-session \
	xfce4-settings \
	xfconf \
	xfce4-power-manager \
	xfce4-notifyd \
	neovim \
	flatpak \
	discord \
	xdg-user-dirs \
	PackageKit-command-not-found \
	fish \
	dnf-automatic \
	wpa_supplicant \
	NetworkManager-wifi

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Qtile
sudo dnf install -y \
	python3-pip \
	python3-xcffib \
	python3-cffi \
	python3-cairocffi
pip install qtile

# Install AppImages
wget -P $HOME/.local/bin/ https://mail.tutanota.com/desktop/tutanota-desktop-linux.AppImage
wget -P $HOME/.local/bin/ https://github.com/FreeTubeApp/FreeTube/releases/download/v0.18.0-beta/FreeTube_0.18.0_amd64.AppImage

# Add flathub and install flatpaks
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y signal bitwarden

# Install VScode
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install -y code
code --extensions-dir=.config/Code/Extensions --install-extension fabiospampinato.vscode-monokai-night
code --extensions-dir=.config/Code/Extensions --install-extension ms-vscode.cpptools
code --extensions-dir=.config/Code/Extensions --install-extension rust-lang.rust-analyzer
code --extensions-dir=.config/Code/Extensions --install-extension vadimcn.vscode-lldb
code --extensions-dir=.config/Code/Extensions --install-extension aaron-bond.better-comments
code --extensions-dir=.config/Code/Extensions --install-extension vscodevim.vim 
code --extensions-dir=.config/Code/Extensions --install-extension streetsidesoftware.code-spell-checker
code --extensions-dir=.config/Code/Extensions --install-extension streetsidesoftware.code-spell-checker-portuguese-brazilian
code --extensions-dir=.config/Code/Extensions --install-extension Gruntfuggly.todo-tree
code --extensions-dir=.config/Code/Extensions --install-extension eamodio.gitlens

while true; do
    read -p "Do you wish to instal remote development extensions" yn
    case $yn in
        [Yy]* ) code --extensions-dir=.config/Code/Extensions --install-extension ms-vscode-remote.remote-ssh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Install docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker
dockerd-rootless-setuptool.sh install --skip-iptables

# Install my configurations
mkdir $HOME/Linux
git --git-dir=$HOME/Linux/dotfiles --work-tree=$HOME init
git --git-dir=$HOME/Linux/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/Linux/dotfiles --work-tree=$HOME pull https://github.com/Alessa-L/dotfiles
sudo cp $HOME/Linux/slick-greeter.conf /etc/lightdm/
sudo cp $HOME/Media/Images/Wallpaper.jpg /usr/share/backgrounds/
sudo cp $HOME/Linux/disable_usb_wakeup.conf /etc/tmpfiles.d/disable_usb_wakeup.conf

# Setup dnf auto-updates
sudo systemctl enable dnf-automatic-install.timer
sudo systemctl start dnf-automatic-install.timer

# Set the xfce/qtile session
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa xfsettingsd
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -t string -s qtile -t string -s start
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client2_Command -t string -s picom -t string -s -b
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client3_Command -t string -sa polybar

# Set nemo to use alacritty as its terminal
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

# Change shell to FISH
chsh -s /bin/fish

# Remove unnecessary files from $HOME
ls -a | grep bash | xargs -d "\n" rm
rm -frd .wget-hsts .lesshst .python_history

sudo systemctl set-default graphical.target
