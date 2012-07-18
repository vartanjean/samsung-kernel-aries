#!/system/bin/sh
BB="/system/xbin/busybox"
if $BB test `$BB cat /sys/class/mtd/mtd2/size` != 397934592 ; then
# we're running on a mtd (old) device
    # we removed /datadata, so migrate data
    $BB mount /data
    if $BB test -h /data/data ; then
      $BB mkdir /datadata
      $BB mount /datadata
      $BB rm /data/data
      $BB mkdir /data/data
      $BB chown system.system /data/data
      $BB chmod 0771 /data/data
      $BB cp -a /datadata/* /data/data/
      $BB rm -r /data/data/lost+found
    fi
    $BB umount /data
fi
