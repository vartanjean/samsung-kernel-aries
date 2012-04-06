#!/bin/bash

echo -en "\033]2;[Aroma Debug Compiling]\007"

#path to the aroma installer directory
cd ~/kernel/android_kernel_samsung_aries/BuildAndPackage/guiSource

#set log
if [ -e buildinstallerdebug.log ] ; then
	rm buildinstallerdebug.log
	exec >> buildinstallerdebug.log 2>&1
	set -x
else
	exec >> buildinstallerdebug.log 2>&1
	set -x
fi

if ! [ -d obj-debug ] ; then
	mkdir -p obj-debug
fi

if ! [ -d bin-debug ] ; then
	mkdir -p bin-debug
fi

cd obj-debug

/opt/toolchains/arm-2009q3/bin/arm-none-linux-gnueabi-gcc -g \
  -save-temps \
  -static \
  -Wl,-s -Werror \
  -DFT2_BUILD_LIBRARY=1 \
  -DDARWIN_NO_CARBON \
    \
      ../libs/zlib/adler32.c \
      ../libs/zlib/adler32_arm.c \
      ../libs/zlib/crc32.c \
      ../libs/zlib/infback.c \
      ../libs/zlib/inffast.c \
      ../libs/zlib/inflate.c \
      ../libs/zlib/inftrees.c \
      ../libs/zlib/zutil.c \
      ../libs/png/png.c \
      ../libs/png/pngerror.c \
      ../libs/png/pnggccrd.c \
      ../libs/png/pngget.c \
      ../libs/png/pngmem.c \
      ../libs/png/pngpread.c \
      ../libs/png/pngread.c \
      ../libs/png/pngrio.c \
      ../libs/png/pngrtran.c \
      ../libs/png/pngrutil.c \
      ../libs/png/pngset.c \
      ../libs/png/pngtrans.c \
      ../libs/png/pngvcrd.c \
      ../libs/minutf8/minutf8.c \
      ../libs/minzip/DirUtil.c \
      ../libs/minzip/Hash.c \
      ../libs/minzip/Inlines.c \
      ../libs/minzip/SysUtil.c \
      ../libs/minzip/Zip.c \
      ../libs/freetype/autofit/autofit.c \
      ../libs/freetype/base/basepic.c \
      ../libs/freetype/base/ftapi.c \
      ../libs/freetype/base/ftbase.c \
      ../libs/freetype/base/ftbbox.c \
      ../libs/freetype/base/ftbitmap.c \
      ../libs/freetype/base/ftdbgmem.c \
      ../libs/freetype/base/ftdebug.c \
      ../libs/freetype/base/ftglyph.c \
      ../libs/freetype/base/ftinit.c \
      ../libs/freetype/base/ftpic.c \
      ../libs/freetype/base/ftstroke.c \
      ../libs/freetype/base/ftsynth.c \
      ../libs/freetype/base/ftsystem.c \
      ../libs/freetype/cff/cff.c \
      ../libs/freetype/pshinter/pshinter.c \
      ../libs/freetype/psnames/psnames.c \
      ../libs/freetype/raster/raster.c \
      ../libs/freetype/sfnt/sfnt.c \
      ../libs/freetype/smooth/smooth.c \
      ../libs/freetype/truetype/truetype.c \
    \
  	  ../src/edify/*.c \
  	  ../src/libs/*.c \
  	  ../src/controls/*.c \
  	  ../src/main/*.c \
  	\
  -I../include \
  -I../src \
  -o ../bin-debug/update-binary \
  -lm -lpthread

cd ..

if [ -e out/update-binary ] ; then
	rm out/update-binary
fi

if ! [ -d out ] ; then
	mkdir out
fi

mv bin-debug/update-binary out/update-binary

rm -rf obj-debug
rm -rf bin-debug
