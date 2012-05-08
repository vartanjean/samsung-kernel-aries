#!/system/bin/sh
#
#set cpu governor lulzactive

echo "lulzactive" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;

#make lulzactive really smooth

echo "50" > /sys/devices/system/cpu/cpufreq/lulzactive/inc_cpu_load;
echo "2" > /sys/devices/system/cpu/cpufreq/lulzactive/pump_up_step;
echo "1" > /sys/devices/system/cpu/cpufreq/lulzactive/pump_down_step;
echo "10000" > /sys/devices/system/cpu/cpufreq/lulzactive/up_sample_time;
echo "40000" > /sys/devices/system/cpu/cpufreq/lulzactive/down_sample_time;
echo "4" > /sys/devices/system/cpu/cpufreq/lulzactive/screen_off_min_step;