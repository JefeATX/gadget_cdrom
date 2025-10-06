#! /bin/bash -eu

IDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$IDIR" ]]; then IDIR="$PWD"; fi

MODE=${1:-hdd}

source "$IDIR/clean.sh"

if [ "$MODE" == "hdd" ] ; then
    modprobe g_mass_storage file=/iso.img luns=1 stall=0 ro=0 cdrom=0 removable=1
elif [ "$MODE" == "cd" ] ; then
    # Check for .cue, .iso, or other file type
    if ls /iso.img 2>/dev/null | grep -q '\.cue$'; then
        cdemu load 0 /iso.img
    else
        mount -o ro,loop /iso.img /iso
    fi
elif [ "$MODE" == "usb" ] ; then
    mount "$(losetup -PLf /iso.img --show)p1" /iso
elif [ "$MODE" == "shutdown" ]; then
    true
fi
