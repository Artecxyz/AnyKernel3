### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=GKI Kernel by @Artecxyz
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

### Kernel version check
## Only allow flashing if the device kernel is >= min_kernel_version
## (leave the value empty to disable this check)
min_kernel_version=6.6.77

## "Linux version 6.6.77-android14-11-g7f2a3b1c ..." -> "6.6.77"
kernel_version=$(cat /proc/version | awk -F '-' '{print $1}' | awk '{print $3}')

## convert x.y.z into a single number so it can be compared: 6.6.77 -> 600060077
kernel_ver=$(echo "$kernel_version" | awk -F. '{printf "%d%04d%04d", $1, $2, $3}')
min_ver=$(echo "$min_kernel_version" | awk -F. '{printf "%d%04d%04d", $1, $2, $3}')

[ "$kernel_ver" -ge "$min_ver" ] && ksu_supported=true || ksu_supported=false

ui_print " " "-> Kernel version: ${kernel_version:-unknown} (min. $min_kernel_version)"
ui_print " " "-> ksu_supported: $ksu_supported"
$ksu_supported && ui_print " " "-> Kernel compatible!"
$ksu_supported || abort "-> Kernel ${kernel_version:-unknown} is not compatible, requires $min_kernel_version or newer."

# boot install
split_boot
if [ -f "split_img/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi
