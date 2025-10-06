#! /bin/bash -eu

IDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$IDIR" ]]; then IDIR="$PWD"; fi

MODE=${1:-hdd}

source "$IDIR/clean.sh"

# Path to your image or cue file (adjust as needed)
CUE=$(ls /opt/gadget_cdrom/*.cue 2>/dev/null | head -n 1)
ISO=$(ls /opt/gadget_cdrom/*.iso 2>/dev/null | head -n 1)
IMG=$(ls /opt/gadget_cdrom/*.img 2>/dev/null | head -n 1)

if [ "$MODE" == "hdd" ] ; then
    modprobe g_mass_storage file=$IMG luns=1 stall=0 ro=0 cdrom=0 removable=1

elif [ "$MODE" == "cd" ] ; then
    if [ -n "$CUE" ]; then
        cdemu load 0 "$CUE"
    elif [ -n "$ISO" ]; then
        mount -o ro,loop "$ISO" /iso
    elif [ -n "$IMG" ]; then
        mount -o ro,loop "$IMG" /iso
    else
        echo "No valid CD image found (CUE, ISO, or IMG)"
        exit 1
    fi

elif [ "$MODE" == "usb" ] ; then
    modprobe g_mass_storage file=$IMG luns=1 stall=0 ro=0 cdrom=0 removable=1

elif [ "$MODE" == "shutdown" ]; then
    true
fi
