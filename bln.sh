#!/bin/sh
build="Devil_1.1.5"

######## Building BLN Kernel ##########################################################

	light="BLN"

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
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
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

echo "launching packaging script"

. ./packaging.inc
release "${version}"
#######################################################################################################################

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
if [ ! -d "release/$light/BFS/no_voodoo" ];
then
	mkdir -p release/$light/BFS/no_voodoo
fi
release/build-scripts/mkshbootimg.py release/$light/BFS/no_voodoo/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"

echo "launching packaging script"

. ./packaging.inc
release "${version}"

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
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
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

echo "launching packaging script"

. ./packaging.inc
release "${version}"

#######################################################################################################################

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

echo "launching packaging script"

. ./packaging.inc
release "${version}"

echo "all done!"
