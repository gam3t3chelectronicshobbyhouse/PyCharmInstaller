#!/bin/bash

DIRECTORY="$(dirname "$(dirname "$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )")")"

function error {
echo -e "\\e[91m$1\\e[39m"
exit 1
}

#Defining Variables
downloadlink=https://download.jetbrains.com/python/pycharm-community-2021.1.tar.gz
name=pycharm

# Get dependencies
sudo apt-get install openjdk-11-jdk 

#Removing if pycharm-community-2021.1.tar.gz already downloaded
rm $name.tar.gz

#Removing pycharm-community-2021.1 if already extracted
sudo rm -r /opt/$name

#Downloading pycharm-community-2021.1.tar.gz
wget $downloadlink -O $name.tar.gz

#Extracting pycharm-community-2021.1.tar.gz to /opt
sudo mkdir /opt/$name
sudo tar xvzf $name.tar.gz -C /opt/$name
sudo mv /opt/$name/*/* /opt/$name/

#Deleting pycharm-community-2021.1.tar.gz
rm $name.tar.gz

#Making file executable
sudo chmod +x /opt/$name/bin/pycharm.sh

#Implementing terminal fix
git clone https://github.com/JetBrains/pty4j.git ~/pty4j
cd ~/pty4j/native
gcc -fPIC -c *.c
gcc -shared -o libpty.so *.o
sudo mkdir /opt/$name/lib/pty4j-native/linux/arm
sudo cp libpty.so /opt/$name/lib/pty4j-native/linux/arm
sudo rm -r ~/pty4j

#Creating desktop shortcut
echo "[Desktop Entry]
Type=Application
Name=PyCharm Community Edition
Icon=/opt/$name/bin/pycharm.svg
Exec=/opt/$name/bin/pycharm.sh %f
Comment=Python IDE 
Categories=Development;IDE;Programming;
Terminal=false
StartupWMClass=jetbrains-pycharm-ce" > /usr/share/applications/jetbrains-pycharm-ce.desktop
