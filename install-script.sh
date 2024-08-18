 #!/bin/bash

if [[ $EUID -e 0 ]]; then
  echo "This script shouldn't be run as root or with sudo it will ask for sudo password when needed only once"
  echo "Exiting..."
  exit 1
fi

MAIN_FILE_DIR=$(dirname "$(readlink -f "$0")")
echo "Script directory: $MAIN_FILE_DIR"

upd-ugr(){
  sudo apt-get update -y && sudo apt upgrade -y
}


upd-ugr


#************************************************************************************************************************************************************************************
#install required packages
sudo apt install -y \
    cmake \
    make \
    ninja-build \
    git \
    build-essential \
    gdb \
    python3-pip \
    qbittorrent \
    python3-venv \
    wireguard \
    nextcloud-desktop \
    nvtop \
    htop \
    net-tools \
    can-utils \
    stlink-tools \
    dfu-util \
    udevadm \
    stty \
    libncursesw5 \
    curl

#************************************************************************************************************************************************************************************
#install sna[ packages
sudo snap install \
    bashtop


#************************************************************************************************************************************************************************************
#install docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo docker run hello-world

# add user to docker group and activate changes
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

upd-ugr

#************************************************************************************************************************************************************************************
#install ros2
sudo apt install software-properties-common
sudo add-apt-repository universe

sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update -y
sudo apt install ros-humble-ros-base -y
sudo apt install ros-dev-tools -y
source /opt/ros/humble/setup.bash

#************************************************************************************************************************************************************************************
# install vscode
rm vscode.deb
curl -L -o vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo dpkg -i vscode.deb
rm vscode.deb


#************************************************************************************************************************************************************************************
# install ollama https://ollama.com/
curl -fsSL https://ollama.com/install.sh | sh


#************************************************************************************************************************************************************************************
# generate ssh-keyrings
if [ ! -d ~/.ssh/id_ed25519.pub ]; then
  ssh-keygen -t ed25519
  echo "Your ssh puiblic key"
  cat ~/.ssh/id_ed25519.pub
fi

# creat eneccessary directioies
mkdir -p ~/.local/bin
mkdir -p ~/.local/share



#************************************************************************************************************************************************************************************
## install self updaeting discord and install vencord
if [ ! -d ~/.local/share/discord-updater ]; then
  echo "Installing discord updater"
  cd ~/.local/share
  git clone https://github.com/X-Lemon-X/discord-updater.git
  discord-updater/./updater-discord.sh
  CRON_JOB="* */1 * * * $HOME/.local/share/discord-updater/./updater-discord.sh"
  (sudo crontab -l | sudo grep -F "$CRON_JOB") || (sudo crontab -l; sudo echo "$CRON_JOB") | sudo crontab -
else 
  echo "Discord updater already installed in: [$HOME/.local/share/discord-updater]"
fi
cd $MAIN_FILE_DIR


#************************************************************************************************************************************************************************************
upd-ugr
sudo apt autoclean -y
sudo apt autoremove -y
sudo apt autoclean -y



#************************************************************************************************************************************************************************************
# configure user groups

# add user to dialout group which allows access to serial ports
sudo usermod -aG dialout $USER
newgrp dialout


