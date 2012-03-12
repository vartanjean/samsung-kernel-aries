#!/bin/sh
rm arch/arm/boot/zImage
build="Devil2_0.1"

######## Building BLN Kernel ##########################################################

	light="LED"

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
export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
#make -j4

echo "creating boot.img"

release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
rm arch/arm/boot/zImage
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
export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
#make -j4

echo "creating boot.img"

release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
rm arch/arm/boot/zImage
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
export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
#make -j4

echo "creating boot.img"

release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
rm arch/arm/boot/zImage
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
export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make -j4

echo "creating boot.img"

release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
echo "..."
echo "boot.img ready"
rm arch/arm/boot/zImage
echo "launching packaging script"

. ./packaging.inc
release "${version}"

echo "all done!"
