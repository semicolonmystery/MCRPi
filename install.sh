#!/bin/bash

if [ $# -lt 4 ]
then
        echo "installation help - bash install [full path to server folder] [server/proxy type] [server version] [server jar name]"
        echo "All arguments are needed!!!"
        echo "If you wanna download bungeecord you can put anything as the version argument but down skip it!!!"
        exit 0
fi

echo "Setting up variables..."
fullPathToServerFolder=$1
serverType=$2
serverVersion=$3
serverJar="$4.jar"
fullPathToJava="$HOME/bin/jdk-17.0.2+8/bin/java"
powerPin=3
startRamMemory="2G"
maxRamMemory="8G"
screenName="minecraft"
IFS="." read -a array <<< $serverVersion
mainVersion="${array[0]}.${array[1]}"

echo "Installing all needed packages..."
sudo apt-get install zip
sudo apt-get install screen
sudo apt-get install jq

echo "Creating all needed directories..."
sudo mkdir $HOME/bin
sudo mkdir $1
sudo rm -r "$1/*"

echo "Downloading and installing java..."
sudo wget -O temurin-17.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.2_8.tar.gz

sudo echo PATH=$PATH:$HOME/bin >> $HOME/.bashrc
source $HOME/.bashrc

sudo tar --extract --file temurin-17.tar.gz --directory=$HOME/bin


if [[ ($serverType == "paper") || ($serverType == "waterfall") || ($serverType == "velocity") ]]
then
        echo "Downloading latest build of $serverType $serverVersion"
        json=$(curl "https://papermc.io/api/v2/projects/$serverType/version_group/$mainVersion/builds")
        build=$(echo $(echo $json | jq ".builds") | jq ".[$(echo $json | jq ".builds|length-1")]")
        buildNumber=$(echo $build | jq '.build')
        fileName=$(echo $(echo $build | jq '.downloads.application.name') | sed 's/^.//;s/.$//')
        sudo wget -O "$fullPathToServerFolder/$serverJar" "https://papermc.io/api/v2/projects/$serverType/versions/$serverVersion/builds/$buildNumber/downloads/$fileName"
elif [[ ($serverType == "spigot") || ($serverType == "craftbukkit") ]]
then
        echo "Downloading latest build of $serverType $serverVersion..."
        sudo wget -O "$fullPathToServerFolder/$serverJar" "https://download.getbukkit.org/$serverType/$serverType-$serverVersion.jar"
elif [[ $serverType == "bungeecord" ]]
then
        echo "Downloading latest build of $serverType..."
        sudo wget -O "$fullPathToServerFolder/$serverJar" "https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar"
else
        echo "You chosed bad server/proxy type!!"
        exit 0
fi

echo "Copying all other files..."
a='s/^fullPathToServerFolder\=.*/fullPathToServerFolder="$fullPathToServerFolder"/'
b='s/^fullPathToJava\=.*/fullPathToJava="$fullPathToJava"/'
c='s/^serverJar\=.*/serverJar="$serverJar"/'
d='s/^powerPin\=.*/powerPin="$powerPin"/'
e='s/^startRamMemory\=.*/startRamMemory="$startRamMemory"/'
f='s/^maxRamMemory\=.*/maxRamMemory="$maxRamMemory"/'
g='s/^screenName\=.*/screenName="$screenName"/'
sudo sed -i $a rc.local
sudo sed -i $b rc.local
sudo sed -i $c rc.local
sudo sed -i $d rc.local
sudo sed -i $e rc.local
sudo sed -i $f rc.local
sudo sed -i $g rc.local
sudo mv rc.local /etc/rc.local
sudo mv MCRPi.py /usr/local/bin/MCRPi.py
exit 0
