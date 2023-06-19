# Install repositories
sudo dnf install -y \
	https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install base groups
sudo dnf group install -y --with-optional \
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
	torbrowser-launcher \
	eom \
	xfce4-screenshooter \
	pcmanfm \
    lxmenu-data \
	file-roller \
	htop \
	libreoffice-gtk3 \
	libreoffice-langpack-pt-BR \
	libreoffice-writer \
	git \
	papirus-icon-theme \
	gparted \
	xfce4-session \
	xfce4-settings \
	xfconf \
	xfce4-power-manager \
	xfce4-notifyd \
	neovim \
	flatpak \
	xdg-user-dirs \
	PackageKit-command-not-found \
	fish \
	wpa_supplicant \
	NetworkManager-wifi \
	blueman

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Qtile
sudo dnf install -y \
	python3-pip \
	python3-xcffib \
	python3-cffi \
	python3-cairocffi
pip install qtile

# Add flathub and install flatpaks
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y bitwarden
sudo flatpak install -y flathub org.mozilla.firefox
sudo flatpak override --filesystem=xdg-data/themes

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
code --extensions-dir=.config/Code/Extensions --install-extension platformio.platformio-ide

while true; do
    read -p "Do you wish to instal remote development extensions" yn
    case $yn in
        [Yy]* ) code --extensions-dir=.config/Code/Extensions --install-extension ms-vscode-remote.remote-ssh; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Install my configurations
mkdir $HOME/Documents/Linux
git --git-dir=$HOME/Documents/Linux/dotfiles --work-tree=$HOME init
git --git-dir=$HOME/Documents/Linux/dotfiles --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/Documents/Linux/dotfiles --work-tree=$HOME pull https://github.com/Alessa-L/dotfiles
sudo cp $HOME/Documents/Linux/slick-greeter.conf /etc/lightdm/
sudo cp $HOME/Media/Images/Wallpaper.jpg /usr/share/backgrounds/
sudo cp $HOME/Documents/Linux/disable_usb_wakeup.conf /etc/tmpfiles.d/disable_usb_wakeup.conf
wget -qO- https://git.io/papirus-folders-install | env PREFIX=$HOME/.local sh
papirus-folders -C white --theme Papirus-Dark

# Set the xfce/qtile session
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa xfsettingsd
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -t string -s qtile -t string -s start
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client2_Command -t string -s picom -t string -s -b
xfconf-query -c xfce4-session -p /sessions/Failsafe/Client3_Command -t string -sa polybar

# Change shell to FISH
chsh -s /bin/fish

sudo systemctl set-default graphical.target
