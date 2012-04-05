#!/system/xbin/busybox sh
#
# this starts the initscript processing and writes log messages
# and/or error messages for debugging of kernel initscripts or
# user/init.d-scripts.
#

# backup and clean logfile and last_kmsg
/system/xbin/busybox cp /data/user.log /data/user.log.bak
/system/xbin/busybox rm /data/user.log

/system/xbin/busybox cp /data/last_kmsg.txt /data/last_kmsg.txt.bak
/system/xbin/busybox cp /proc/last_kmsg /data/last_kmsg.txt

# start logging
exec >>/data/user.log
exec 2>&1

# start logfile output
echo
echo "************************************************"
echo "DEVIL-ICS BOOT LOG (thanks Mialwe)"
echo "************************************************"
echo

# log basic system information
echo -n "Kernel: ";/system/xbin/busybox uname -r
echo -n "PATH: ";echo $PATH
echo -n "ROM: ";cat /system/build.prop|/system/xbin/busybox grep ro.build.display.id
echo

# set busybox location
BB="/system/xbin/busybox"

# print file contents <string messagetext><file output>
cat_msg_sysfile() {
    MSG=$1
    SYSFILE=$2
    echo -n "$MSG"
    cat $SYSFILE
}


# partitions
echo; echo "mount"
#busybox mount -o remount,noatime,barrier=0,nobh /system
#busybox mount -o remount,noatime,barrier=0,nobh /cache
#busybox mount -o remount,noatime /data
for i in $($BB mount | $BB grep relatime | $BB cut -d " " -f3);do
    busybox mount -o remount,noatime $i
done
mount

# set cpu max freq
echo; echo "cpu"
bootspeed=`cat /etc/devil/bootspeed`
if $BB [[ "$bootspeed" -eq 1400000 || "$bootspeed" -eq 1300000 || "$bootspeed" -eq 1200000 || "$bootspeed" -eq 1080000  || "$bootspeed" -eq 1000000 || "$bootspeed" -eq 800000 ]];then
    echo "CPU: found vaild bootspeed: <$bootspeed>"
    echo $bootspeed > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
else
	echo "CPU: did not find vaild bootspeed: setting 1000"
	echo 1000000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi



# debug output
cat_msg_sysfile "max           : " /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
cat_msg_sysfile "gov           : " /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
cat_msg_sysfile "UV_mv         : " /sys/devices/system/cpu/cpu0/cpufreq/UV_mV_table
cat_msg_sysfile "states_enabled: " /sys/devices/system/cpu/cpu0/cpufreq/states_enabled_table
echo
echo "freq/voltage  : ";cat /sys/devices/system/cpu/cpu0/cpufreq/frequency_voltage_table


# vm tweaks
# just output of default values for now
echo; echo "vm"
echo "0" > /proc/sys/vm/swappiness                   # Not really needed as no /swap used...
echo "2000" > /proc/sys/vm/dirty_writeback_centisecs # Flush after 20sec. (o:500)
echo "2000" > /proc/sys/vm/dirty_expire_centisecs    # Pages expire after 20sec. (o:200)
echo "10" > /proc/sys/vm/dirty_background_ratio      # flush pages later (default 5% active mem)
echo "65" > /proc/sys/vm/dirty_ratio                 # process writes pages later (default 20%)  
echo "3" > /proc/sys/vm/page-cluster
echo "0" > /proc/sys/vm/laptop_mode
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "0" > /proc/sys/vm/panic_on_oom
echo "1" > /proc/sys/vm/overcommit_memory
cat_msg_sysfile "swappiness: " /proc/sys/vm/swappiness                   
cat_msg_sysfile "dirty_writeback_centisecs: " /proc/sys/vm/dirty_writeback_centisecs
cat_msg_sysfile "dirty_expire_centisecs: " /proc/sys/vm/dirty_expire_centisecs    
cat_msg_sysfile "dirty_background_ratio: " /proc/sys/vm/dirty_background_ratio
cat_msg_sysfile "dirty_ratio: " /proc/sys/vm/dirty_ratio 
cat_msg_sysfile "page-cluster: " /proc/sys/vm/page-cluster
cat_msg_sysfile "laptop_mode: " /proc/sys/vm/laptop_mode
cat_msg_sysfile "oom_kill_allocating_task: " /proc/sys/vm/oom_kill_allocating_task
cat_msg_sysfile "panic_on_oom: " /proc/sys/vm/panic_on_oom
cat_msg_sysfile "overcommit_memory: " /proc/sys/vm/overcommit_memory

# security enhancements
# rp_filter must be reset to 1 if TUN module is used (issues)
echo; echo "sec"
echo 0 > /proc/sys/net/ipv4/ip_forward
echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 2 > /proc/sys/net/ipv6/conf/all/use_tempaddr
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo -n "SEC: ip_forward :";cat /proc/sys/net/ipv4/ip_forward
echo -n "SEC: rp_filter :";cat /proc/sys/net/ipv4/conf/all/rp_filter
echo -n "SEC: use_tempaddr :";cat /proc/sys/net/ipv6/conf/all/use_tempaddr
echo -n "SEC: accept_source_route :";cat /proc/sys/net/ipv4/conf/all/accept_source_route
echo -n "SEC: send_redirects :";cat /proc/sys/net/ipv4/conf/all/send_redirects
echo -n "SEC: icmp_echo_ignore_broadcasts :";cat /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts 

# setprop tweaks
echo; echo "prop"
setprop wifi.supplicant_scan_interval 180
echo -n "wifi.supplicant_scan_interval (is this actually used?): ";getprop wifi.supplicant_scan_interval

# kernel tweaks
echo; echo "kernel"
echo "NO_GENTLE_FAIR_SLEEPERS" > /sys/kernel/debug/sched_features
echo 500 512000 64 2048 > /proc/sys/kernel/sem 
echo 3000000 > /proc/sys/kernel/sched_latency_ns
echo 500000 > /proc/sys/kernel/sched_wakeup_granularity_ns
echo 500000 > /proc/sys/kernel/sched_min_granularity_ns
echo 0 > /proc/sys/kernel/panic_on_oops
echo 0 > /proc/sys/kernel/panic
cat_msg_sysfile "sched_features: " /sys/kernel/debug/sched_features
cat_msg_sysfile "sem: " /proc/sys/kernel/sem; 
cat_msg_sysfile "sched_latency_ns: " /proc/sys/kernel/sched_latency_ns
cat_msg_sysfile "sched_wakeup_granularity_ns: " /proc/sys/kernel/sched_wakeup_granularity_ns
cat_msg_sysfile "sched_min_granularity_ns: " /proc/sys/kernel/sched_min_granularity_ns
cat_msg_sysfile "panic_on_oops: " /proc/sys/kernel/panic_on_oops
cat_msg_sysfile "panic: " /proc/sys/kernel/panic

# set sdcard read_ahead
echo; echo "read_ahead_kb"
cat_msg_sysfile "default: " /sys/devices/virtual/bdi/default/read_ahead_kb
if $BB [[ "$readahead" -eq 64 || "$readahead" -eq 128 || "$readahead" -eq 256 || "$readahead" -eq 512  || "$readahead" -eq 1024 || "$readahead" -eq 2048 || "$readahead" -eq 3096 ]];then
    echo "CPU: found vaild readahead: <$readahead>"
else
    readahead=512
fi
echo $readahead > /sys/devices/virtual/bdi/179:0/read_ahead_kb
echo $readahead > /sys/devices/virtual/bdi/179:8/read_ahead_kb
cat_msg_sysfile "179.0: " /sys/devices/virtual/bdi/179:0/read_ahead_kb
cat_msg_sysfile "179.8: " /sys/devices/virtual/bdi/179:8/read_ahead_kb

# small fs read_ahead
echo 16 > /sys/block/mtdblock2/queue/read_ahead_kb # system
echo 16 > /sys/block/mtdblock3/queue/read_ahead_kb # cache
echo 64 > /sys/block/mtdblock6/queue/read_ahead_kb # datadata

      
# general tweaks
for i in $MTD $MMC $LOOP;do
    echo "$iosched" > $i/queue/scheduler
    echo 0 > $i/queue/rotational
    echo 0 > $i/queue/iostats
done

# mtd/mmc only tweaks
for i in $MTD $MMC;do
    echo 1024 > $i/queue/nr_requests
done

for i in $MTD $MMC $LOOP $RAM;do
    cat_msg_sysfile "$i/queue/scheduler: " $i/queue/scheduler
    cat_msg_sysfile "$i/queue/rotational: " $i/queue/rotational
    cat_msg_sysfile "$i/queue/iostats: " $i/queue/iostats
    cat_msg_sysfile "$i/queue/read_ahead_kb: " $i/queue/read_ahead_kb
    cat_msg_sysfile "$i/queue/rq_affinity: " $i/queue/rq_affinity   
    cat_msg_sysfile "$i/queue/nr_requests: " $i/queue/nr_requests
    echo
done



# debug output BLN
echo;echo "bln"
cat_msg_sysfile "/sys/class/misc/backlightnotification/enabled: " /sys/class/misc/backlightnotification/enabled


# load profile
echo; echo "profile"
profile=`cat /etc/devil/profile`
if [ $profile = "smooth" ]; then
    $BB chmod +x /data/local/devil/smooth.sh;
    logwrapper /system/bin/sh /data/local/devil/smooth.sh;
fi


if [ $profile = "powersave" ]; then
    $BB chmod +x /data/local/devil/powersave.sh;
    logwrapper /system/bin/sh /data/local/devil/powersave.sh;
fi


# speed to default
echo 1000000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
echo "set max freq to default"

# live_oc_mode
echo; echo "live_oc_mode"
if [ -e "/etc/devil/live_oc_mode" ];then
    live_oc_mode=`cat /etc/devil/live_oc_mode`
    echo $live_oc_mode > /sys/devices/virtual/misc/liveoc/selective_oc
    echo "liveoc mode set to: $live_oc_mode"
else
    echo "did not find vaild live_oc_mode: setting 1"
    echo 1 > /sys/devices/virtual/misc/liveoc/selective_oc
fi;

# init.d support 
# executes <E>scriptname, <S>scriptname, <0-9><0-9>scriptname
# in this order.
echo; echo "init.d"
echo "creating /system/etc/init.d..."


#if $BB [ "$initd" == "true" ];then
    echo "starting init.d script execution..."
    echo $(date) USER EARLY INIT START from /system/etc/init.d
    if cd /system/etc/init.d >/dev/null 2>&1 ; then
        for file in E* ; do
            if ! cat "$file" >/dev/null 2>&1 ; then continue ; fi
            echo "init.d: START '$file'"
            /system/bin/sh "$file"
            echo "init.d: EXIT '$file' ($?)"
        done
    fi
    echo $(date) USER EARLY INIT DONE from /system/etc/init.d

    echo $(date) USER INIT START from /system/etc/init.d
    if cd /system/etc/init.d >/dev/null 2>&1 ; then
        for file in S* ; do
            if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
            echo "init.d: START '$file'"
            /system/bin/sh "$file"
            echo "init.d: EXIT '$file' ($?)"
        done
    fi
    echo $(date) USER INIT DONE from /system/etc/init.d

    echo $(date) USER INIT START from /system/etc/init.d
    if cd /system/etc/init.d >/dev/null 2>&1 ; then
        for file in [0-9][0-9]* ; do
            if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
            echo "init.d: START '$file'"
            /system/bin/sh "$file"
            echo "init.d: EXIT '$file' ($?)"
        done
    fi
    echo $(date) USER INIT DONE from /system/etc/init.d


