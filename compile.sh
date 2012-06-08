#!/bin/sh

export USE_CCACHE=1

        CCACHE=ccache
        CCACHE_COMPRESS=1
        CCACHE_DIR=/home/dominik/android/ccache
        export CCACHE_DIR CCACHE_COMPRESS
###########################################################################################################
target="$1"

number="0.71"
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
