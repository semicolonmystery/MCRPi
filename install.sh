#!/bin/bash

echo "Setting up variables..."
source configurations.conf
fullPathToJavaFolder="$HOME/bin/java/jdk-17.0.2+8/bin"
IFS="." read -a array <<< $serverVersion
mainVersion="${array[0]}.${array[1]}"

echo "Installing all needed packages..."
sudo apt-get install zip
sudo apt-get install screen
sudo apt-get install jq

echo "Creating all needed directories..."
sudo mkdir $HOME/bin
sudo mkdir $HOME/bin/java
sudo mkdir $fullPathToServerFolder
sudo rm -r "$fullPathToServerFolder/*"

echo "Downloading and installing java..."
sudo wget -O temurin-17.tar.gz https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.2%2B8/OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.2_8.tar.gz

sudo echo PATH=$PATH:$fullPathToJavaFolder >> $HOME/.bashrc

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
echo "Setting all boot variables..."
sudo echo '#!/bin/sh -e' >> rc.local
sudo echo '' >> rc.local
sudo echo 'sudo python3 /usr/local/bin/MCRPi.py $fullPathToServerFolder $fullPathToJava $serverJar $powerPIN $startRamMemory $maxRamMemory $screenName' >> rc.local
sudo echo '' >> rc.local
sudo echo 'exit 0' >> rc.local
echo "Copying all other files..."
sudo mv rc.local /etc/rc.local
sudo mv MCRPi.py /usr/local/bin/MCRPi.py
exit 0