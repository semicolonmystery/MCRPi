#!/bin/bash

echo "Setting up variables..."
source ./configurations.conf
IFS="." read -a array <<< $serverVersion
mainVersion="${array[0]}.${array[1]}"

echo "Installing all needed packages..."
sudo apt-get update -y
sudo apt-get install zip -y
sudo apt-get install screen -y
sudo apt-get install jq -y
sudo apt-get install openjdk-17-jdk -y

echo "Creating all needed directories..."
sudo mkdir $fullPathToServerFolder
sudo rm -r "$fullPathToServerFolder/$serverJar"

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
echo "Setting all other needed things..."
sudo echo "#!/bin/sh -e" >> rc.local
sudo echo "" >> rc.local
sudo echo "sudo python3 /usr/local/bin/MCRPi.py $fullPathToServerFolder java $serverJar $powerPin $startRamMemory $maxRamMemory $screenName > /dev/null 2>&1 &" >> rc.local
sudo echo "" >> rc.local
sudo echo "exit 0" >> rc.local
sudo echo "eula=true" >> eula.txt
echo "Copying all needed files..."
sudo mv rc.local /etc/rc.local
sudo mv eula.txt $fullPathToServerFolder
sudo chmod +x /etc/rc.local
sudo cp MCRPi.py /usr/local/bin/MCRPi.py
echo "Starting up server..."
sudo sh /etc/rc.local

exit 0
