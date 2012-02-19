#REL=${version}_$(date +%Y%m%d).zip
REL=${version}_$(date +%Y%m%d)

rm -r release/system 2> /dev/null
mkdir  -p release/system/bin || exit 1
mkdir  -p release/system/lib/modules || exit 1
mkdir  -p release/system/lib/hw || exit 1
mkdir  -p release/system/etc/init.d || exit 1
#cp release/logger.module release/system/lib/modules/logger.ko
find . -name "*.ko" -exec cp {} release/system/lib/modules/ \; 2>/dev/null || exit 1

cd release && {
#	cp 91logger system/etc/init.d/ || exit 1
#	cp S98system_tweak system/etc/init.d/ || exit 1
#	cp 98crunchengine system/etc/init.d/ || exit 1
	cp S70zipalign system/etc/init.d/ || exit 1
#	cp lights.aries.so system/lib/hw/ || exit 1
#        cp lights.aries.so.BLN system/lib/hw/lights.aries.so || exit 1
	mkdir -p system/bin
#	cp bin/rild_old system/bin/rild
#	cp libril.so_old system/lib/libril.so
#	cp libsecril-client.so_old system/lib/libsecril-client.so
	zip -q -r "${REL}.zip" system boot.img META-INF erase_image flash_image bml_over_mtd bml_over_mtd.sh || exit 1
	sha256sum ${REL}.zip > ${REL}.sha256sum


#	rm -rf ${TYPE} || exit 1
#	mkdir -p ${TYPE} || exit 1
#	mv ${REL}* ${TYPE} || exit 1
} || exit 1

mv *.zip $light/$scheduler/$color/${REL}.zip
mv *.sha256sum $light/$scheduler/$color/${REL}.sha256sum

echo ${REL}
rm system/lib/modules/*
rm system/lib/hw/*
rm system/etc/init.d/*
rm system/bin/*
exit 0
