#!/bin/bash

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=/home/demo/Public/samsung-kernel-aries/toolchain/bin/arm-linux-gnueabihf-
rm /home/demo/Documents/android_kernel_samsung_wave-jellybean/usr/initramfs_data.cpio
make cyanogenmod_galaxysmtd_defconfig
make -j2
