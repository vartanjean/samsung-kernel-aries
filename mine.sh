#!/bin/sh
rm arch/arm/boot/zImage
build="Devil2_0.3"

scheduler="CFS"

color="CMC"

light="LED"

version="$build"_"$scheduler"_"$light"_"$color"
export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
mv init/version.c init/version.backup
mv init/version.neu init/version.c
echo "building kernel"
make aries_galaxysmtd_defconfig
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
