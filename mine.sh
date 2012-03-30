#!/bin/sh
rm arch/arm/boot/zImage

rom=""

handy="i9000"

build="Devil2_0.56XL_bm""$rom"_"$handy"

scheduler="CFS"

color="CMC"

light="BLN"

version="$build"_"$scheduler"_"$light"_"$color"
export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"

if [ "$handy" = "i9000"  ] 
then
make aries_galaxysmtd_defconfig
fi

if [ "$handy" = "cappy"  ] 
then
make aries_captivatemtd_defconfig
fi

make -j4

echo "creating boot.img"
if [ "$handy" = "i9000"  ] 
then
release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
fi

if [ "$handy" = "cappy"  ] 
then
release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/captivate_ramdisk/ramdisk.img release/ramdisks/captivate_ramdisk/ramdisk-recovery.img
fi

if [ "$rom" = "isense"  ] 
then
release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/sense/ramdisk.img release/ramdisks/sense/ramdisk-recovery.img
fi
echo "..."
echo "boot.img ready"
rm arch/arm/boot/zImage
echo "launching packaging script"

. ./packaging.inc
release "${version}"

echo "all done!"
