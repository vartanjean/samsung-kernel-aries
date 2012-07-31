#!/system/xbin/busybox sh
#
# Flash utilities for CWM flashing MIUI/CM roms for Samsung Galaxy S Phones, using AROMA-Installer
# (c) 2011 by RolluS @ Team MyUI
#

# Install busybox applets in memory
# to call a busybox applet, just call $APPLET without - or _ or .
CAT="/system/xbin/busybox cat"
CHMOD="/system/xbin/busybox chmod"
CHOWN="/system/xbin/busybox chown"
CUT="/system/xbin/busybox cut"
ECHO="/system/xbin/busybox echo"
EGREP="/system/xbin/busybox egrep"
FIND="/system/xbin/busybox find"
GREP="/system/xbin/busybox grep"
LN="/system/xbin/busybox ln"
MKDIR="/system/xbin/busybox mkdir"
RM="/system/xbin/busybox rm"
SED="/system/xbin/busybox sed"
TEST="/system/xbin/busybox test"


set_perm() { # same as set_perm command in updater-script, for example:
#
# set_perm 0 3003 02750 "/system/bin/netcfg"
#
# sets user:group to 0:3003 and perm to 02750
    $CHOWN $1:$2 $4
	$CHMOD $3 $4
}
set_perm_recursive() { # same as set_perm command in updater-script, for example:
#
# set_perm_recursive 0 2000 0755 0755 "/system/bin"
#
# sets uid:gid to 0:2000 and perm to 0755 for folders and 0755 for files
    $CHOWN -R $1:$2 $5
	$CHMOD $3 $5
	#chmod recursive of folder
	$FIND $5/* -type d |while read folder; do
		$CHMOD $3 $folder
	done
	#chmod recursive of files
	$FIND $5/* -type f |while read file; do
		$CHMOD $4 $file
	done
}

#create destination folders
$FIND /data/sys-parts -type d | $SED "s|/data/sys-parts/||" | while read dossier; do
	if ! $TEST -e /system/$dossier; then
		$MKDIR -p /system/$dossier
	fi
done

#install sys-parts
$FIND /data/sys-parts -type f | $SED "s|/data/sys-parts/||" | while read fichier; do
	if $TEST -e /system/$fichier; then
		$RM /system/$fichier
	fi
	$LN -s /data/sys-parts/$fichier /system/$fichier
	$ECHO "Symlinked: /system/$fichier -> /data/sys-parts/$fichier"
done

if $TEST -e /data/sys-parts/addon.d/70-gapps.sh; then
set_perm 0 0 0755 "/data/sys-parts/addon.d/70-gapps.sh"
fi
if $TEST -e /data/sys-parts/addon.d/71-gapps-faceunlock.sh; then
set_perm 0 0 0755 "/data/sys-parts/addon.d/71-gapps-faceunlock.sh"
fi
set_perm_recursive 0 2000 0755 755 "/data/sys-parts"
