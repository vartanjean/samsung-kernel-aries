#!/bin/sh
rm arch/arm/boot/zImage

rom=""

mem="XL"

handy="i9000"

<<<<<<< HEAD
number="0.76"

build="Devil3"_"$number""$rom"_"$handy"
=======
build="Devil3_0.70""$rom"_"$handy"
>>>>>>> f4efb7d... revert 3.1.10

scheduler="CFS"

color="CMC"

light="BLN"
if [ "$mem" = "cm" ]
then
version="$build"_"$scheduler"_"$light"_"$color"
else
version="$build"_"$scheduler"_"$light"_"$color"_"$mem"
fi
# export KBUILD_BUILD_VERSION="$build"_"$scheduler"_"$color"
 sed "/Devil/c\ \" ("$version")\"" init/version.c > init/version.neu
 mv init/version.c init/version.backup
 mv init/version.neu init/version.c
echo "building kernel"

if [ "$handy" = "i9000"  ] 
then
	if [ "$rom" = "sense"  ] 
	then
	make sense_i9000_defconfig
	else
	make aries_galaxysmtd_defconfig
	fi
fi

if [ "$handy" = "i9000B"  ] 
then
make aries_galaxysbmtd_defconfig
fi

if [ "$handy" = "cappy"  ] 
then
	if [ "$rom" = "sense"  ] 
	then
	make sense_i9000_defconfig
	else
	make aries_captivatemtd_defconfig
	fi
fi

if [ "$handy" = "vibrant"  ] 
then
make aries_vibrantmtd_defconfig
fi

make -j4

echo "creating boot.img"
if [ "$handy" = "i9000"  ] || [ "$handy" = "cappy"  ] || [ "$handy" = "vibrant"  ]
then
release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
fi

echo "..."
echo "boot.img ready"
rm arch/arm/boot/zImage
echo "launching packaging script"

. ./packaging.inc
release "${version}"

echo "all done!"
