#!/bin/sh
rm arch/arm/boot/zImage

rom="sense"

mem="cm"

handy="cappy"

number="0.72"

build="Devil3"_"$number""$rom"_"$handy"

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

if [ "$handy" = "fascinate"  ] 
then
make aries_fascinatemtd_defconfig
fi

# make -j4
find . -name "*.ko" -exec rm -rf {} \; 2>/dev/null || exit 1
make -j4 modules
if [ "$handy" = "i9000"  ] 
then
find . -name "*.ko" -exec cp {} usr/galaxysmtd_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi

if [ "$handy" = "i9000b"  ] 
then
find . -name "*.ko" -exec cp {} usr/galaxysbmtd_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi

make -j4 modules
if [ "$handy" = "cappy"  ] 
then
find . -name "*.ko" -exec cp {} usr/captivatemtd_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi

if [ "$handy" = "vibrant"  ] 
then
find . -name "*.ko" -exec cp {} usr/vibrantmtd_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi

if [ "$handy" = "fascinate"  ] 
then
find . -name "*.ko" -exec cp {} usr/fascinate_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi

if [ "$rom" = "sense"  ] && [ "$handy" = "i9000"  ] 
then
find . -name "*.ko" -exec cp {} usr/i9000_sense_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi

if [ "$rom" = "sense"  ] && [ "$handy" = "cappy"  ] 
then
find . -name "*.ko" -exec cp {} usr/cappy_sense_initramfs/files/modules/ \; 2>/dev/null || exit 1
fi


make -j4 zImage

echo "creating boot.img"
cp arch/arm/boot/zImage ./release/zImage
cp arch/arm/boot/zImage ./release/boot.img

#if [ "$handy" = "i9000"  ] || [ "$handy" = "cappy"  ] || [ "$handy" = "vibrant"  ]
#then
#release/build-scripts/mkshbootimg.py release/boot.img arch/arm/boot/zImage release/ramdisks/galaxys_ramdisk/ramdisk.img release/ramdisks/galaxys_ramdisk/ramdisk-recovery.img
#fi

echo "..."
echo "boot.img ready"
#rm arch/arm/boot/zImage
echo "launching packaging script"

. ./packaging.inc
release "${version}"

echo "all done!"
