#!/bin/sh

export USE_CCACHE=1

        CCACHE=ccache
        CCACHE_COMPRESS=1
        CCACHE_DIR="/home/dominik/android/ccache"
	CCACHE_LOGFILE="/home/dominik/android/ccache/ccache-log"
        export CCACHE_DIR CCACHE_COMPRESS CCACHE_LOGFILE
###########################################################################################################

target="$1"

if [ "$2" = "vc"  ] || [ "$3" = "vc" ]
	then
	vc="yes"
fi

if [ "$2" = "vc"  ]
	then
	scheduler="CFS"
	else
	scheduler="$2"
fi

number="1.0.1_datadata"

if [ "$scheduler" != "BFS"  ] && [ "$scheduler" != "bfs" ]
	then
	scheduler="CFS"
	else
	scheduler="BFS"
fi

rm -rf usr/galaxysmtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/galaxysmtd_initramfs/
cp usr/init_files/init_gsm usr/galaxysmtd_initramfs/init
cp usr/init_files/boot-patch.sh usr/galaxysmtd_initramfs/ics_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/galaxysmtd_initramfs/ics_init/sbin/clean_initd.sh

cp usr/init_files/boot-patch.sh usr/galaxysmtd_initramfs/jb_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/galaxysmtd_initramfs/jb_init/sbin/clean_initd.sh


rm -rf usr/galaxysbmtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/galaxysbmtd_initramfs/
cp usr/init_files/init_gsm usr/galaxysbmtd_initramfs/init
cp usr/init_files/boot-patch.sh usr/galaxysbmtd_initramfs/ics_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/galaxysbmtd_initramfs/ics_init/sbin/clean_initd.sh

cp usr/init_files/boot-patch.sh usr/galaxysbmtd_initramfs/jb_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/galaxysbmtd_initramfs/jb_init/sbin/clean_initd.sh


rm -rf usr/captivatemtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/captivatemtd_initramfs/
cp usr/init_files/init_gsm usr/captivatemtd_initramfs/init
cp usr/init_files/boot-patch.sh usr/captivatemtd_initramfs/ics_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/captivatemtd_initramfs/ics_init/sbin/clean_initd.sh

cp usr/init_files/boot-patch.sh usr/captivatemtd_initramfs/jb_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/captivatemtd_initramfs/jb_init/sbin/clean_initd.sh


rm -rf usr/vibrantmtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/vibrantmtd_initramfs/
cp usr/init_files/init_gsm usr/vibrantmtd_initramfs/init
cp usr/init_files/boot-patch.sh usr/vibrantmtd_initramfs/ics_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/vibrantmtd_initramfs/ics_init/sbin/clean_initd.sh

cp usr/init_files/boot-patch.sh usr/vibrantmtd_initramfs/jb_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/vibrantmtd_initramfs/jb_init/sbin/clean_initd.sh


rm -rf usr/fascinatemtd_initramfs/files/*
cp -r  usr/init_files/files/ usr/fascinatemtd_initramfs/
cp usr/init_files/init_cdma usr/fascinatemtd_initramfs/init
cp usr/init_files/boot-patch.sh usr/fascinatemtd_initramfs/ics_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/fascinatemtd_initramfs/ics_init/sbin/clean_initd.sh

cp usr/init_files/boot-patch.sh usr/fascinatemtd_initramfs/jb_init/sbin/boot-patch.sh
cp usr/init_files/clean_initd.sh usr/fascinatemtd_initramfs/jb_init/sbin/clean_initd.sh


if [ "$target" != "fassy"  ] && [ "$target" != "all"  ] 
####################### prepare building for gsm device ###########################################################
then
	if [ -f drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm ]
	then
	cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3
	cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm drivers/misc/samsung_modemctl/built-in.o
	echo "Built-in.o modem files for GSM copied"
	else
	echo "***** built-in.o.gcc4.4.3_gsm files are missing *****"
	echo "******** Please build old GSM *********"
	exit 1
	fi
fi

if [ "$target" = "fassy"  ]
####################### prepare building for cdma device ###########################################################
then
	if [ -f drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm ]
	then
	cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_cdma drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3
	cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_cdma drivers/misc/samsung_modemctl/built-in.o
	echo "Built-in.o modem files for CDMA copied"
	else
	echo "***** built-in.o.gcc4.4.3_cdma files are missing *****"
	echo "******** Please build old CDMA *********"
	exit 1
	fi
fi

if [ "$target" = "i9000"  ] 
then
./i9000.sh "${number}" "${scheduler}" "${vc}"
fi

if [ "$target" = "i9000b"  ] 
then
./brasil.sh "${number}" "${scheduler}" "${vc}"
fi

if [ "$target" = "cappy"  ] 
then
./cappy.sh "${number}" "${scheduler}" "${vc}"
fi

if [ "$target" = "fassy"  ] 
then
./fassy.sh "${number}" "${scheduler}" "${vc}"
fi

if [ "$target" = "vibrant"  ] 
then
./vibrant.sh "${number}" "${scheduler}" "${vc}"
fi


if [ "$target" = "all"  ] 
then

####################### prepare building for gsm device ###########################################################
if [ -f drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm ]
then
cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3
cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm drivers/misc/samsung_modemctl/built-in.o
#cp drivers/misc/samsung_modemctl/modemctl/built-in.o.gcc4.4.3_gsm drivers/misc/samsung_modemctl/modemctl/built-in.o.gcc4.4.3
#cp drivers/misc/samsung_modemctl/modemctl/built-in.o.gcc4.4.3_gsm drivers/misc/samsung_modemctl/modemctl/built-in.o
echo "Built-in.o modem files for GSM copied"
else
echo "***** built-in.o.gcc4.4.3_gsm files are missing *****"
echo "******** Please build old GSM *********"
exit 1
fi
./i9000.sh "${number}" "${scheduler}" "${vc}"
./brasil.sh "${number}" "${scheduler}" "${vc}"
./cappy.sh "${number}" "${scheduler}" "${vc}"
./vibrant.sh "${number}" "${scheduler}" "${vc}"

####################### prepare building for cdma device ###########################################################
if [ -f drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_gsm ]
then
cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_cdma drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3
cp drivers/misc/samsung_modemctl/built-in.o.gcc4.4.3_cdma drivers/misc/samsung_modemctl/built-in.o
echo "Built-in.o modem files for GSM copied"
else
echo "***** built-in.o.gcc4.4.3_gsm files are missing *****"
echo "******** Please build old GSM *********"
exit 1
fi
./fassy.sh "${number}" "${scheduler}" "${vc}"
fi
