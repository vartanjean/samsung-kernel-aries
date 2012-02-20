#!/bin/sh
build="Devil_1.1"

########################### Building LED Kernel ################################################################
	light="LED"

	rm "arch/arm/mach-s5pv210/aries-touchkey-led.c"
	cp "arch/arm/mach-s5pv210/aries-touchkey-led.led" "arch/arm/mach-s5pv210/aries-touchkey-led.c"
	
	rm "drivers/input/keyboard/cypress-touchkey.c"
	cp "drivers/input/keyboard/cypress-touchkey.led" "drivers/input/keyboard/cypress-touchkey.c"

	sed -i 's/^.*BLD.*$//' arch/arm/configs/aries_galaxysmtd_defconfig
	echo 'CONFIG_BLD=y' >> arch/arm/configs/aries_galaxysmtd_defconfig

	sed -i 's/^.*KEYPAD_CYPRESS_TOUCH_BLN.*$//' arch/arm/configs/aries_galaxysmtd_defconfig
	echo '# CONFIG_KEYPAD_CYPRESS_TOUCH_BLN is not set' >> arch/arm/configs/aries_galaxysmtd_defconfig

	sed -e "/^ *$/d" arch/arm/configs/aries_galaxysmtd_defconfig > arch/arm/configs/galaxys_defconfig
	mv arch/arm/configs/aries_galaxysmtd_defconfig arch/arm/configs/aries_galaxysmtd_defconfig_backup
	mv arch/arm/configs/galaxys_defconfig arch/arm/configs/aries_galaxysmtd_defconfig


########################## BFS kernel ##########################################
scheduler="BFS"
echo "building for galaxy s"
make aries_galaxysmtd_defconfig


sed -i 's/^.*SCHED_BFS.*$//' .config
echo 'CONFIG_SCHED_BFS=y' >> .config

sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=y
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
color="VC"
version="$build"_"$scheduler"_"$light"_"$color"
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building "$scheduler" Kernel with "$light" and "$color""
make -j4

echo "creating boot.img"
if [ ! -d "release/$light/$scheduler/$color" ];
then
	mkdir -p release/$light/$scheduler/$color
fi
release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"

echo "launching packaging script"
#./release/doit.sh
#REL=${version}_$(date +%Y%m%d).zip
REL=${version}_$(date +%Y%m%d)

rm -r release/system 2> /dev/null
mkdir  -p release/system/bin || exit 1
mkdir  -p release/system/lib/modules || exit 1
mkdir  -p release/system/lib/hw || exit 1
mkdir  -p release/system/etc/init.d || exit 1
#cp release/logger.module release/system/lib/modules/logger.ko
find . -name "*.ko" -exec cp {} release/system/lib/modules/ \; 2>/dev/null || exit 1

cd release && {
#	cp 91logger system/etc/init.d/ || exit 1
#	cp S98system_tweak system/etc/init.d/ || exit 1
#	cp 98crunchengine system/etc/init.d/ || exit 1
#	cp S70zipalign system/etc/init.d/ || exit 1

if [ "$light" = "BLN" ] 
then
        cp lights.aries.so.BLN system/lib/hw/lights.aries.so || exit 1
	cp updater-script.BLN META-INF/com/google/android/updater-script || exit 1
else
	cp lights.aries.so system/lib/hw/|| exit 1
	cp lights.goldfish.so system/lib/hw/|| exit 1
	cp updater-script.LED META-INF/com/google/android/updater-script || exit 1
fi

	mkdir -p system/bin
#	cp bin/rild_old system/bin/rild
#	cp libril.so_old system/lib/libril.so
#	cp libsecril-client.so_old system/lib/libsecril-client.so
	zip -q -r "${REL}.zip" system boot.img META-INF erase_image flash_image bml_over_mtd bml_over_mtd.sh || exit 1
	sha256sum ${REL}.zip > ${REL}.sha256sum


#	rm -rf ${TYPE} || exit 1
#	mkdir -p ${TYPE} || exit 1
#	mv ${REL}* ${TYPE} || exit 1
} || exit 1

#mv *.zip $light/$scheduler/$color/${REL}.zip
#mv *.sha256sum $light/$scheduler/$color/${REL}.sha256sum

echo ${REL}
rm system/lib/modules/*
rm system/lib/hw/*
rm system/etc/init.d/*
rm system/bin/*
exit 0
exit 0



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
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make -j4

echo "creating boot.img"
if [ ! -d "release/$light/BFS/no_voodoo" ];
then
	mkdir -p release/$light/BFS/no_voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/BFS/no_voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"


########################## CFS kernel ###########################
scheduler="CFS"
make aries_galaxysmtd_defconfig
echo "building CFS kernel with voodoo color"
sed -i 's/^.*SCHED_BFS.*$//' .config
echo 'CONFIG_SCHED_BFS=n
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RCU_TORTURE_TEST is not set' >> .config

sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=y
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
color="VC"
version="$build"_"$scheduler"_"$light"_"$color"
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
#make -j4

echo "creating boot.img"
if [ ! -d "release/$light/CFS/voodoo" ];
then
	mkdir -p release/$light/CFS/voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/CFS/voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"


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
#make -j4

echo "creating boot.img"
if [ ! -d "release/$light/CFS/no_voodoo" ];
then
	mkdir -p release/$light/CFS/no_voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/CFS/no_voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"



######## Building BLN Kernel ##########################################################

	light="BLN"

	rm "arch/arm/mach-s5pv210/aries-touchkey-led.c"
	cp "arch/arm/mach-s5pv210/aries-touchkey-led.bln" "arch/arm/mach-s5pv210/aries-touchkey-led.c"
	
	rm "drivers/input/keyboard/cypress-touchkey.c"
	cp "drivers/input/keyboard/cypress-touchkey.bln" "drivers/input/keyboard/cypress-touchkey.c"

	sed -i 's/^.*BLD.*$//' arch/arm/configs/aries_galaxysmtd_defconfig
	echo '# CONFIG_BLD is not set' >> arch/arm/configs/aries_galaxysmtd_defconfig

	sed -i 's/^.*KEYPAD_CYPRESS_TOUCH_BLN.*$//' arch/arm/configs/aries_galaxysmtd_defconfig
	echo 'CONFIG_KEYPAD_CYPRESS_TOUCH_BLN=y' >> arch/arm/configs/aries_galaxysmtd_defconfig

	sed -e "/^ *$/d" arch/arm/configs/aries_galaxysmtd_defconfig

############### BFS kernel #########################
scheduler="BFS"
echo "building for galaxy s"
make aries_galaxysmtd_defconfig
echo "building BFS kernel with voodoo color"
sed -i 's/^.*SCHED_BFS.*$//' .config
echo 'CONFIG_SCHED_BFS=y' >> .config

sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=y
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
color="VC"
version="$build"_"$scheduler"_"$light"_"$color"
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make -j4

echo "creating boot.img"
if [ ! -d "release/$light/BFS/voodoo" ];
then
	mkdir -p release/$light/BFS/voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/BFS/voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"

#echo "launching packaging script"
#./release/doit.sh

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
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make -j4

echo "creating boot.img"
if [ ! -d "release/$light/BFS/no_voodoo" ];
then
	mkdir -p release/$light/BFS/no_voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/BFS/no_voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"


########################### CFS kernel #############################################
scheduler="CFS"
make aries_galaxysmtd_defconfig
echo "building CFS kernel with voodoo color"
sed -i 's/^.*SCHED_BFS.*$//' .config
echo 'CONFIG_SCHED_BFS=n
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RCU_TORTURE_TEST is not set' >> .config

sed -i 's/^.*FB_VOODOO.*$//' .config
echo 'CONFIG_FB_VOODOO=y
CONFIG_FB_VOODOO_DEBUG_LOG=n' >> .config
color="VC"
version="$build"_"$scheduler"_"$light"_"$color"
sed "/Devil/c\ \"("$version" )\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
 make -j4

echo "creating boot.img"
if [ ! -d "release/$light/CFS/voodoo" ];
then
	mkdir -p release/$light/CFS/voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/CFS/voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"


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
if [ ! -d "release/$light/CFS/no_voodoo" ];
then
	mkdir -p release/$light/CFS/no_voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/CFS/no_voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"

echo "all done!"
