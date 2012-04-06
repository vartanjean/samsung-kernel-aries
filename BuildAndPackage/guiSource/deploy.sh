#!/bin/bash

echo -en "\033]2;[Aroma Deploying]\007"

#make sure to specify the path to adb if you need to
adb push out/update-binary /data/
adb shell chmod 777 /data/update-binary
adb shell /data/update-binary 1 0 /sdcard/test.zip
read -p "Press [Enter] key to cleanup."
adb shell rm /data/update-binary
