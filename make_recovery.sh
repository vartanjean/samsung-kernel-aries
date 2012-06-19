#!/bin/bash

recovery="$1"
handy="$2"

cd $ANDROID_HOME/bootable
#just in case ....
mv recovery/ ../../backup
rm -rf recovery/*
#########################
cd ..
cd ..
if [ "$recovery" = "cwm"  ] 
then
cp -r cwm/ $ANDROID_HOME/bootable/
mv $ANDROID_HOME/bootable/cwm/* $ANDROID_HOME/bootable/recovery/
rm -rf $ANDROID_HOME/bootable/cwm
elif [ "$recovery" = "twrp"  ] 
then
cp -r twrp/ $ANDROID_HOME/bootable/
mv $ANDROID_HOME/bootable/twrp/* $ANDROID_HOME/bootable/recovery/
rm -rf $ANDROID_HOME/bootable/twrp
else
echo "error. usage: ./make_recovery.sh recoverytyp (cwm or twrp), optional: handy (i9000, cappy, fassy or vibrant)" && exit 1
fi

if [ "$recovery" = "cwm"  ] 
then
cp cwm_files/BoardConfigCommon.mk $ANDROID_HOME/device/samsung/aries-common/BoardConfigCommon.mk
cp cwm_files/recovery.rc $ANDROID_HOME/device/samsung/aries-common/recovery.rc
cp cwm_files/fassy/fascinatemtd.mk $ANDROID_HOME/device/samsung/fascinatemtd/fascinatemtd.mk
cp cwm_files/fassy/BoardConfig.mk $ANDROID_HOME/device/samsung/fascinatemtd/BoardConfig.mk
else
cp twrp_files/BoardConfigCommon.mk $ANDROID_HOME/device/samsung/aries-common/BoardConfigCommon.mk
cp twrp_files/recovery.rc $ANDROID_HOME/device/samsung/aries-common/recovery.rc
cp twrp_files/fassy/fascinatemtd.mk $ANDROID_HOME/device/samsung/fascinatemtd/fascinatemtd.mk
cp twrp_files/fassy/BoardConfig.mk $ANDROID_HOME/device/samsung/fascinatemtd/BoardConfig.mk
fi
cd $ANDROID_HOME 
if [ "$handy" != '' ]
then
	if [ "$handy" = "i9000"  ] 
	then
	echo "making i9000 $1 recovery"
	. build/envsetup.sh && lunch full_galaxysmtd-user && make bootimage
	fi
	if [ "$handy" = "vibrant"  ] 
	then
	echo "making vibrant $1 recovery"
	. build/envsetup.sh && lunch full_vibrantmtd-eng && make bootimage
	fi
	if [ "$handy" = "fassy"  ] 
	then
	echo "making fassy $1 recovery"
	. build/envsetup.sh && lunch full_fascinatemtd-eng && make bootimage
	fi
	if [ "$handy" = "cappy"  ] 
	then
	echo "making cappy $1 recovery"
	. build/envsetup.sh && lunch full_captivatemtd-eng && make bootimage
	fi
else
echo "making i9000 $1 recovery"
. build/envsetup.sh && lunch full_galaxysmtd-user && make bootimage
echo "making vibrant $1 recovery"
. build/envsetup.sh && lunch full_vibrantmtd-eng && make bootimage
echo "making fassy $1 recovery"
. build/envsetup.sh && lunch full_fascinatemtd-eng && make bootimage
echo "making cappy $1 recovery"
. build/envsetup.sh && lunch full_captivatemtd-eng && make bootimage
fi

echo "all recoveries created"
#cd $ANDROID_HOME/bootable
#rm -rf recovery/*
cd $ANDROID_HOME/kernel/android_kernel_samsung_aries
