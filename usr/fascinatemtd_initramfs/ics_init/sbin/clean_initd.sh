#!/system/xbin/busybox sh
#
# this cleans init.d from know files
#

BB="/system/xbin/busybox"

# start logging
$BB rm -fr /cache/clean_initd

cd system/etc/init.d
$BB rm -fr S05enable_oc_0800
$BB rm -fr S05enable_oc_1000_default
$BB rm -fr S05enable_oc_1100
$BB rm -fr S05enable_oc_1140
$BB rm -fr S05enable_oc_1200
$BB rm -fr S10enable_gov_cons_savebattery
$BB rm -fr S10enable_gov_conservative
$BB rm -fr S10enable_gov_ondemand_default
$BB rm -fr S10enable_gov_ondemand_efficient
$BB rm -fr S10enable_gov_ondemand_smooth
$BB rm -fr S10enable_gov_smartassV2
$BB rm -fr S12disable_lock_min
$BB rm -fr S12enable_lock_min
$BB rm -fr S15enable_sched_deadline	
$BB rm -fr S15enable_sched_noop_default	
$BB rm -fr S15enable_sched_sio
$BB rm -fr S20disable_netfilter	
$BB rm -fr S20enable_netfilter	
$BB rm -fr S22disable_deepidle	
$BB rm -fr S22enable_deepidle	
$BB rm -fr S24disable_didle_stats
$BB rm -fr S24enable_didle_stats	
$BB rm -fr S30disable_logger	
$BB rm -fr S30enable_logger	
$BB rm -fr S35disable_tun	
$BB rm -fr S35enable_tun	
$BB rm -fr S40disable_cifs	
$BB rm -fr S40enable_cifs	
$BB rm -fr S44enable_semaautobr_bright
$BB rm -fr S44enable_semaautobr_dark	
$BB rm -fr S44enable_semaautobr_default	
$BB rm -fr S44enable_semaautobr_normal	
$BB rm -fr S45enable_vibrator_1default
$BB rm -fr S45enable_vibrator_2high	
$BB rm -fr S45enable_vibrator_3medium	
$BB rm -fr S45enable_vibrator_4low	
$BB rm -fr S45enable_vibrator_5min	
$BB rm -fr S46disable_configgz	
$BB rm -fr S46enable_configgz	
$BB rm -fr S47disable_radio	
$BB rm -fr S47enable_radio	
$BB rm -fr S48disable_mouse
$BB rm -fr S48enable_mouse
$BB rm -fr S50disable_xpad
$BB rm -fr S50enable_xpad
$BB rm -fr S80enable_touchwake_15
$BB rm -fr S80enable_touchwake_30
$BB rm -fr S80enable_touchwake_45
$BB rm -fr S80enable_touchwake_60
$BB rm -fr S80enable_touchwake_90
$BB rm -fr S80enable_touchwake_default
$BB rm -fr S80enable_bt_off
$BB rm -fr S74enable_lmk_32mb
$BB rm -fr S74enable_lmk_48mb_default
$BB rm -fr S74enable_lmk_64mb	
$BB rm -fr S74enable_lmk_80mb	
$BB rm -fr S74enable_lmk_mi70mb	
$BB rm -fr S74enable_lmk_sc60mb	
$BB rm -fr S76enable_sdcard_0128kb_default	
$BB rm -fr S76enable_sdcard_0256kb	
$BB rm -fr S76enable_sdcard_0512kb
$BB rm -fr S76enable_sdcard_1024kb	
$BB rm -fr S76enable_sdcard_3072kb	
$BB rm -fr S78enable_touchscreen_0_default	
$BB rm -fr S78enable_touchscreen_1
$BB rm -fr S78enable_touchscreen_2
$BB rm -fr 90call_vol_fascinate
$BB rm -fr 90screenstate_scaling
$BB rm -fr S98rfkill_didle
$BB rm -fr S99screenstate_scaling
