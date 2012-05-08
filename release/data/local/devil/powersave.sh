#!/system/bin/sh
#
#set cpu governor conservative

echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor;

#make conservative really power saving

echo "95" > /sys/devices/system/cpu/cpufreq/conservative/up_threshold;
echo "60000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate;
echo "1" > /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor;
echo "40" > /sys/devices/system/cpu/cpufreq/conservative/down_threshold;
echo "10" > /sys/devices/system/cpu/cpufreq/conservative/freq_step;