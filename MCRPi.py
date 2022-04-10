# !/bin/python

import RPi.GPIO as GPIO
import subprocess
import time
import os
import sys

fullPathToServerFolder = sys.argv[1]
fullPathToJava = sys.argv[2]
serverJar = sys.argv[3]
powerPIN = int(sys.argv[4])
startRamMemory = sys.argv[5]
maxRamMemory = sys.argv[6]
screenName = sys.argv[7]


def startListening(GPIO_PIN, screenName):
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(GPIO_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.wait_for_edge(GPIO_PIN, GPIO.FALLING)

    subprocess.call(["screen", "-Rd", screenName, "-X", "stuff", 'stop\r'], shell=False)
    while str(subprocess.Popen(["screen", "-ls"], shell=False, stdout=subprocess.PIPE).stdout.readlines()).find(screenName) != -1:
        time.sleep(1)
    subprocess.call(["sudo", "shutdown", "-h", "now"], shell=False)


def startMC(screenName, fullPathToJava, serverJar, startRamMemory, maxRamMemory):
    subprocess.call(["screen", "-dmS", screenName, fullPathToJava, "-Xms" + startRamMemory, "-Xmx" + maxRamMemory, "-jar", serverJar], shell=False)

os.chdir(fullPathToServerFolder)
startMC(screenName, fullPathToJava, serverJar, startRamMemory, maxRamMemory)
startListening(powerPIN, screenName)