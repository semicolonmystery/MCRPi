# MCRPi
This small program can setup new minecraft server in less than five minutes with boot and shutdown scripts. You can shutdown you raspberry pi by a button but dont worry about that server that is running becose it will shutdown before raspberry pi. That server will automaticaly run after every boot.

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
