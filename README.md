# MCRPi
This program will automaticaly configure minecraft server with button shutdown and other shutdown scripts and much more. It even supports bungeecord. It even has power saving mode if someone is not playing on spefific server for some time, than it will shutdown that server and raspberry pi.

Step by step:
  1. Open terminal on your raspberry pi and run these commands:<br/>
    ```sudo apt-get install git```<br/>
    ```git clone github.com/Verustus/MCRPi```<br/>
    ```cd MCRPi```<br/>
    ```chmod +x install.sh```<br/>
    ```nano configurations.conf```<br/>
  2. Now edit the file you are in.
  3. After that you need to run ```./install.sh``` and it should setup everything.
  4. Now you can just modify file server.properties in your minecraft server folder.
