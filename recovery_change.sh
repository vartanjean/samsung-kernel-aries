#!/bin/sh
cd release/ramdisks/galaxys_ramdisk/touch/sbin
#rm recovery
mv recovery* recovery
cd ..
find . | cpio -o -H newc | gzip > ../ramdisk-recovery.img
exit 0
