#!/bin/sh

export USE_CCACHE=1

        CCACHE=ccache
        CCACHE_COMPRESS=1
        CCACHE_DIR=/home/dominik/android/ccache
        export CCACHE_DIR CCACHE_COMPRESS
###########################################################################################################

rm -rf usr/galaxysmtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/galaxysmtd_initramfs/
cp  usr/init_files/init_gsm usr/galaxysmtd_initramfs/init
cp  usr/init_files/boot-patch.sh usr/galaxysmtd_initramfs/ics_init/sbin/boot-patch.sh

rm -rf usr/galaxysbmtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/galaxysbmtd_initramfs/
cp  usr/init_files/init_gsm usr/galaxysbmtd_initramfs/init
cp  usr/init_files/boot-patch.sh usr/galaxysbmtd_initramfs/ics_init/sbin/boot-patch.sh

rm -rf usr/captivatemtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/captivatemtd_initramfs/
cp  usr/init_files/init_gsm usr/captivatemtd_initramfs/init
cp  usr/init_files/boot-patch.sh usr/captivatemtd_initramfs/ics_init/sbin/boot-patch.sh

rm -rf usr/vibrantmtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/vibrantmtd_initramfs/
cp  usr/init_files/init_gsm usr/vibrantmtd_initramfs/init
cp  usr/init_files/boot-patch.sh usr/vibrantmtd_initramfs/ics_init/sbin/boot-patch.sh

rm -rf usr/fascinatemtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/fascinatemtd_initramfs/
cp  usr/init_files/init_cdma usr/fascinatemtd_initramfs/init
cp  usr/init_files/boot-patch.sh usr/fascinatemtd_initramfs/ics_init/sbin/boot-patch.sh

target="$1"

number="0.79"
if [ "$target" = "i9000"  ] 
then
./i9000.sh "${number}"
exit 0
fi

if [ "$target" = "i9000b"  ] 
then
./brasil.sh "${number}"
exit 0
fi

if [ "$target" = "cappy"  ] 
then
./cappy.sh "${number}"
exit 0
fi

if [ "$target" = "fassy"  ] 
then
./fassy.sh "${number}"
exit 0
fi

if [ "$target" = "vibrant"  ] 
then
./vibrant.sh "${number}"
exit 0
fi

./i9000.sh "${number}"
./brasil.sh "${number}"
./cappy.sh "${number}"
./fassy.sh "${number}"
./vibrant.sh "${number}"
