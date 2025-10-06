#! /bin/bash -eu

IDIR="${BASH_SOURCE%/*}"
if [[ ! -d "$IDIR" ]]; then IDIR="$PWD"; fi

MODE=${1:-hdd}

source "$IDIR/clean.sh"

# Path to your image or cue file (adjust if needed)
IMG_PATH="/iso.img"
CUE_PATH="/iso.cue"
ISO_PATH="/iso.iso"

if [ "$MODE" == "hdd" ] ; then
    modprobe g_mass_storage file=$IMG_PATH luns=1 stall=0 ro=0 cdrom=0 removable=1

elif [ "$MODE" == "cd" ] ; then
    # Prefer CUE if present, otherwise ISO
    if [ -f "$CUE_PATH" ]; then
        cdemu load 0 "$CUE_PATH"
    elif [ -f "$ISO_PATH" ]; then
        mount -o ro,loop "$ISO_PATH" /iso
    elif [ -f "$IMG_PATH" ]; then
        # Try ISO mount for .img (if it's a real ISO)
        mount -o ro,loop "$IMG_PATH" /iso
    else
        echo "No valid CD image found (CUE, ISO, or IMG)"
        exit 1
    fi

elif [ "$MODE" == "usb" ] ; then
    # Use g_mass_storage for USB mode (removable disk)
    modprobe g_mass_storage file=$IMG_PATH luns=1 stall=0 ro=0 cdrom=0 removable=1

elif [ "$MODE" == "shutdown" ]; then
    true
fi
