if [ -e "/data/local/devil/swap_use" ]; then
swap_use=`cat /data/local/devil/swap_use`
	if [ "$swap_use" -eq 1 ]; then

	# Detect the swap partition
	SWAP_PART=`fdisk -l /dev/block/mmcblk1 | grep swap | sed 's/\(mmcblk1p[0-9]*\).*/\1/'`

		if [ -n "$SWAP_PART" ]; then
    			# If exists a swap partition activate it and create the fstab file
    			echo "Found swap partition at $SWAP_PART"
    			SWAP_RESULT=`swapon $SWAP_PART 2>&1 | grep "not implemented"` 
    			if [ -z "$SWAP_RESULT" ]; then
				swapoff /dev/block/zram0 >/dev/null 2>&1
				echo 1 > /sys/block/zram0/reset >/dev/null 2>&1
				echo "zram deactivated and disabled"
         			echo "$SWAP_PART swap swap" > /system/etc/fstab
        			swapon -a
        			echo 60 > /proc/sys/vm/swappiness
        			echo "Swap partition activated successfully!"
    			else
        			echo "Current kernel does not support swap!"
    			fi
		else
    			echo "Swap partition not found!"
		fi

	elif [ "$swap_use" -eq 2 ]; then
	swapoff -a
	rm /system/etc/fstab
	echo "Swap partition deactivated successfully!"

	RAMSIZE=`grep MemTotal /proc/meminfo | awk '{ print \$2 }'`
	ZRAMSIZE=$(($RAMSIZE*200))
	insmod /system/lib/modules/zram.ko
	echo 1 > /sys/block/zram0/reset
	echo $ZRAMSIZE > /sys/block/zram0/disksize
	mkswap /dev/block/zram0
	swapon /dev/block/zram0
	echo "zram enabled and activated"
	fi
fi
