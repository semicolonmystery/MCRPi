I haven't looked on this for a long time so I am not even sure if it works but you can try.

# MCRPi
This is a small program that can setup new minecraft server in less than five minutes with boot and shutdown scripts. You can shutdown you raspberry pi with a button but dont worry about the server that is currently running because it will shutdown before raspberry pi. The server will automaticaly start running right after boot.

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

Also if you want to get to the console type ```sudo screen -ls``` and then ```sudo screen -r id```(replace the id with the number before the .minecraft)
