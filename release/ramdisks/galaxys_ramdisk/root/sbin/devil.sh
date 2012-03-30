#!/system/bin/sh
#
# ensure that devil init.d scripts always are present at boot time
#
# create S80profiles in init.d if not existing

echo "#!/system/bin/sh" > /system/etc/init.d/S80profiles
echo "#" >> /system/etc/init.d/S80profiles
echo 'profile=`cat /etc/devil/profile`' >> /system/etc/init.d/S80profiles
echo "if [ $profile = "smooth" ]; then" >> /system/etc/init.d/S80profiles 
echo "    busybox chmod +x /data/local/devil/smooth.sh;" >> /system/etc/init.d/S80profiles
echo "    logwrapper /system/bin/sh /data/local/devil/smooth.sh;" >> /system/etc/init.d/S80profiles
echo "fi" >> /system/etc/init.d/S80profiles
echo "if [ $profile = "powersave" ]; then" >> /system/etc/init.d/S80profiles 
echo "    busybox chmod +x /data/local/devil/powersave.sh;" >> /system/etc/init.d/S80profiles
echo "    logwrapper /system/bin/sh /data/local/devil/powersave.sh;" >> /system/etc/init.d/S80profiles
echo "fi" >> /system/etc/init.d/S80profiles

