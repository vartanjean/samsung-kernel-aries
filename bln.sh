#!/bin/sh
build="Devil_1.1"
######## Building BLN Kernel ##########################################################

	light="BLN"

#	rm "arch/arm/mach-s5pv210/aries-touchkey-led.c"
#	cp "arch/arm/mach-s5pv210/aries-touchkey-led.bln" "arch/arm/mach-s5pv210/aries-touchkey-led.c"

#	rm "drivers/input/keyboard/cypress-touchkey.c"
#	cp "drivers/input/keyboard/cypress-touchkey.bln" "drivers/input/keyboard/cypress-touchkey.c"

	sed -i 's/^.*BLD.*$//' arch/arm/configs/aries_galaxysmtd_defconfig
	echo '# CONFIG_BLD is not set' >> arch/arm/configs/aries_galaxysmtd_defconfig

#	sed -i 's/^.*KEYPAD_CYPRESS_TOUCH_BLN.*$//' arch/arm/configs/aries_galaxysmtd_defconfig
#	echo 'CONFIG_KEYPAD_CYPRESS_TOUCH_BLN=y' >> arch/arm/configs/aries_galaxysmtd_defconfig

	sed -e "/^ *$/d" arch/arm/configs/aries_galaxysmtd_defconfig > arch/arm/configs/aries_galaxysmtd_neu
	mv arch/arm/configs/aries_galaxysmtd_neu arch/arm/configs/aries_galaxysmtd_defconfig

############### BFS kernel #########################
scheduler="BFS"

echo "building for galaxy s"
make aries_galaxysmtd_defconfig
echo "building BFS kernel without voodoo color"
sed -i 's/^.*SCHED_BFS.*$//' .config
echo 'CONFIG_SCHED_BFS=y' >> .config

sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=n
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
color="CMC"
version="$build"_"$scheduler"_"$light"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make -j4

echo "creating boot.img"

release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"

echo "launching packaging script"

. ./packaging.inc
release "${version}"

rm /release/boot.img

exit 0
########################### CFS kernel #############################################
scheduler="CFS"
echo "building for galaxy s"
make aries_galaxysmtd_defconfig
echo "building CFS kernel without voodoo color"
sed -i 's/^.*SCHED_BFS.*$//' .config
echo 'CONFIG_SCHED_BFS=n
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RCU_TORTURE_TEST is not set' >> .config

sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=n
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
color="CMC"
version="$build"_"$scheduler"_"$light"_"$color"
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make -j4

echo "creating boot.img"

release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"

echo "launching packaging script"

. ./packaging.inc
release "${version}"

rm boot.img

echo "all done!"
