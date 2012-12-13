#!/tmp/busybox sh
#
# Universal Updater Script for Samsung Galaxy S Phones
# (c) 2011 by Teamhacksung
# Combined GSM & CDMA version
#

check_mount() {
    if ! /tmp/busybox grep -q $1 /proc/mounts ; then
        /tmp/busybox mkdir -p $1
        /tmp/busybox umount -l $2
        if ! /tmp/busybox mount -t $3 $2 $1 ; then
            /tmp/busybox echo "Cannot mount $1."
            exit 1
        fi
    fi
}

set_log() {
    rm -rf $1
    exec >> $1 2>&1
}

# ui_print by Chainfire
OUTFD=$(/tmp/busybox ps | /tmp/busybox grep -v "grep" | /tmp/busybox grep -o -E "update_binary(.*)" | /tmp/busybox cut -d " " -f 3);
ui_print() {
  if [ $OUTFD != "" ]; then
    echo "ui_print ${1} " 1>&$OUTFD;
    echo "ui_print " 1>&$OUTFD;
  else
    echo "${1}";
  fi;
}

set -x
export PATH=/:/sbin:/system/xbin:/system/bin:/tmp:$PATH

# Check if we're in CDMA or GSM mode
if /tmp/busybox test "$1" = cdma ; then
    # CDMA mode
    IS_GSM='/tmp/busybox false'
    SD_PART='/dev/block/mmcblk1p1'
    MMC_PART='/dev/block/mmcblk0p1 /dev/block/mmcblk0p2'
    MTD_SIZE='490733568'
else
    # GSM mode
    IS_GSM='/tmp/busybox true'
    SD_PART='/dev/block/mmcblk0p1'
    MMC_PART='/dev/block/mmcblk0p2'
    MTD_SIZE='442499072'
fi

# check for old/non-cwm recovery.
if ! /tmp/busybox test -n "$UPDATE_PACKAGE" ; then
    # scrape package location from /tmp/recovery.log
    UPDATE_PACKAGE=`/tmp/busybox cat /tmp/recovery.log | /tmp/busybox grep 'Update location:' | /tmp/busybox tail -n 1 | /tmp/busybox cut -d ' ' -f 3-`
fi

if /tmp/busybox test `/tmp/busybox cat /sys/class/mtd/mtd2/size` != "$MTD_SIZE" || \
    /tmp/busybox test `/tmp/busybox cat /sys/class/mtd/mtd2/name` != "datadata" || \
    /tmp/busybox test ! -e /dev/lvpool/secondary_system ; then
    # we're running on a mtd (old) device

    # make sure sdcard is mounted
    check_mount /sdcard $SD_PART vfat

    # everything is logged into /sdcard/cyanogenmod_mtd_old.log
    set_log /sdcard/cyanogenmod_mtd_old.log

    if ! /tmp/busybox test -e /.accept_wipe ; then
        /tmp/busybox touch /.accept_wipe
        ui_print
        ui_print "============================================"
        ui_print "This Kernel uses an incompatible partition layout"
        ui_print "Your /data will be wiped upon installation"
        ui_print "Run this update.zip again to confirm install"
        ui_print "============================================"
        ui_print
        exit 9
    fi
    /tmp/busybox rm /.accept_wipe

    # write the package path to sdcard cyanogenmod.cfg
    if /tmp/busybox test -n "$UPDATE_PACKAGE" ; then
        /tmp/busybox echo "$UPDATE_PACKAGE" > /sdcard/cyanogenmod.cfg
    fi

    # inform the script that this is an old mtd upgrade
    /tmp/busybox echo 1 > /sdcard/cyanogenmod.mtdupd

    # clear datadata
    /tmp/busybox umount -l /datadata
    /tmp/erase_image datadata

    # write new kernel to boot partition
    /tmp/bml_over_mtd.sh boot 72 reservoir 2004 /tmp/boot.img

	# Remove /system/build.prop to trigger emergency boot
	/tmp/busybox mount /system
	/tmp/busybox rm -f /system/build.prop
	/tmp/busybox umount -l /system

    /tmp/busybox sync

    /sbin/reboot now
    exit 0

elif /tmp/busybox test -e /dev/block/mtdblock0 ; then
    # we're running on a mtd (current) device

    # make sure sdcard is mounted
    check_mount /sdcard $SD_PART vfat

    # everything is logged into /sdcard/cyanogenmod.log
    set_log /sdcard/cyanogenmod_mtd.log

    if ! /tmp/busybox test -e /sdcard/cyanogenmod.cfg ; then
        # update install - flash boot image then skip back to updater-script
        # (boot image is already flashed for first time install or old mtd upgrade)

        # flash boot image
        /tmp/bml_over_mtd.sh boot 72 reservoir 2004 /tmp/boot.img

        if ! $IS_GSM ; then
            /tmp/bml_over_mtd.sh recovery 102 reservoir 2004 /tmp/recovery_kernel
        fi

	# unmount system (recovery seems to expect system to be unmounted)
	/tmp/busybox umount -l /system

        exit 0
    fi

    # if a cyanogenmod.cfg exists, then this is a first time install
    # let's format the volumes

    # remove the cyanogenmod.cfg to prevent this from looping
    /tmp/busybox rm -f /sdcard/cyanogenmod.cfg

    # unmount system and data (recovery seems to expect system to be unmounted)
    /tmp/busybox umount -l /system
    /tmp/busybox umount -l /data

    # setup lvm volumes
    /lvm/sbin/lvm pvcreate $MMC_PART
    /lvm/sbin/lvm vgcreate lvpool $MMC_PART
    /lvm/sbin/lvm lvcreate -L 400M -n system lvpool
    /lvm/sbin/lvm lvcreate -L 400M -n secondary_system lvpool
    /lvm/sbin/lvm lvcreate -l 100%FREE -n userdata lvpool

    # format data and secondary_system
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -l -16384 -a /data /dev/lvpool/userdata
    /tmp/make_ext4fs -b 4096 -g 32768 -i 8192 -I 256 -l -16384 -a /data /dev/lvpool/secondary_system

    # unmount and format datadata
    /tmp/busybox umount -l /datadata
    /tmp/erase_image datadata


    if /tmp/busybox test -e /sdcard/cyanogenmod.mtdupd ; then
        # this is an upgrade with changed MTD mapping for /data, /cache, /system
        # so return to updater-script after formatting them

        /tmp/busybox rm -f /sdcard/cyanogenmod.mtdupd

        exit 0
    fi

    exit 0
fi

