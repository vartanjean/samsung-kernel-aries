#!/sbin/sh
# Installer script for Team ICSSGS
# © 2012 Team ICSSGS
# Written by DemonWav

set -x
PATH=$PATH:/tmp:/tmp/updates

BUSYBOX="/tmp/icssgs-data/busybox"

mount_part()
{
	if ! [ $($BUSYBOX mount | $BUSYBOX grep "/$1" | $BUSYBOX wc -l) -eq "1" ] ; then
		$BUSYBOX mkdir -p /$1
		$BUSYBOX umount -l /dev/block/$2
		if ! $BUSYBOX mount -t $3 /dev/block/$2 /$1 ; then
			echo "$1 cannot be mounted successfully."
		fi
	else
		$BUSYBOX umount -l /dev/block/$2
		if ! $BUSYBOX mount -t $3 /dev/block/$2 /$1 ; then
			echo "$1 cannot be mounted successfully."
		fi
	fi
}

partitionchecker()
{
	if [ $($BUSYBOX cat /proc/partitions | $BUSYBOX grep "mmcblk0p2" | $BUSYBOX wc -l) != 1 ] ; then
		TYPE=CDMA
	elif [ $($BUSYBOX cat /proc/partitions | $BUSYBOX grep "mtdblock2" | $BUSYBOX grep "256000" | $BUSYBOX wc -l) == 1 ] ; then
		TYPE=GSM_MTD
	elif [ $($BUSYBOX cat /proc/partitions | $BUSYBOX grep "mtdblock2" | $BUSYBOX grep "192000" | $BUSYBOX wc -l) == 1 ] ; then
		TYPE=GSM_MTD_CM7
	elif [ $($BUSYBOX cat /proc/partitions | $BUSYBOX grep "bml11" | $BUSYBOX grep "35840" | $BUSYBOX wc -l) == 1 ] ; then
		TYPE=GSM_BML
	elif [ $($BUSYBOX cat /proc/partitions | $BUSYBOX grep "bml11" | $BUSYBOX grep "179200" | $BUSYBOX wc -l) == 1 ] ; then
		TYPE=CDMA_BML
	fi
}

devicechecker()
{
	if [ $TYPE == "GSM_MTD"] ; then
		exit 0
	elif [ $TYPE == "GSM_BML" ] ; then
		exit 1
	elif [ $TYPE == "GSM_MTD_CM7" ] ;then
		exit 2
	elif [ $TYPE == "CDMA" ] ; then
		exit 3
	fi
}

mount_sdcard()
{
	mount_part sdcard mmcblk0p1 vfat
}

cleanup()
{
	mount_part sdcard mmcblk0p1 vfat
	$BUSYBOX rm -rf /sdcard/icssgsinstall
}

save_logs()
{
	mount_part sdcard mmcblk0p1 vfat

	if [ -e /sdcard/install_log ] ; then
		$BUSYBOX rm -f /sdcard/install_log
		$BUSYBOX mkdir -p /sdcard/icssgslogs
		$BUSYBOX cp -f /tmp/recovery.log /sdcard/icssgslogs/recovery.log
		$BUSYBOX cp -f /tmp/icssgs-data/.install.log /sdcard/icssgslogs/install.log
		$BUSYBOX cp -f /sdcard/bml_over_mtd.log /sdcard/icssgslogs/bml_over_mtd.log
	fi
	$BUSYBOX rm  /sdcard/bml_over_mtd.log
}

$1
$2
