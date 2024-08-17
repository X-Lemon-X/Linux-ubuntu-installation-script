 #!/bin/bash

upd-ugr(){
    sudo apt-get update -y && sudo apt upgrade -y
}


upd-ugr

#install required packages
sudo apt install -y \
    cmake \
    make \
    ninja-build \
    git \
    build-essential \
    gdb \
    nextcloud-desktop \
    wireguard \
    can-utils \
    python3-pip \
    qbittorrent \
    python3-venv \
    nvtop \
    htop \
    net-tools

#install sna[ packages
sudo snap install \
    bashtop

upd-ugr

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

upd-ugr

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

upd-ugr

# install vscode
rm vscode.deb
curl -L -o vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
sudo dpkg -i vscode.deb
rm vscode.deb


# install ollama https://ollama.com/
curl -fsSL https://ollama.com/install.sh | sh


# generate ssh-keyrings

if [ -d ~/.ssh/id_ed25519.pub ] then
    ssh-keygen -t ed25519
    echo "Your ssh puiblic key"
    cat ~/.ssh/id_ed25519.pub
fi

# creat eneccessary directioies
mkdir -p ~/.local/bin


upd-ugr
sudo apt autoclean -y
sudo apt autoremove -y
sudo apt autoclean -y



