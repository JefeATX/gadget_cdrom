#!/bin/bash -eu

iso="$1"
MODE=${2:-cd}

# Only mount as USB mass storage for USB/HDD mode, and ISO for CD-ROM
if [ "$MODE" == "cd" ]; then
    # If it's a .cue file, use cdemu, otherwise use g_mass_storage as a CD-ROM
    if [[ "$iso" == *.cue ]]; then
        cdemu load 0 "$iso"
    else
        modprobe g_mass_storage file="$iso" luns=1 stall=0 ro=1 cdrom=1 removable=1
    fi
elif [ "$MODE" == "usb" ]; then
    modprobe g_mass_storage file="$iso" luns=1 stall=0 ro=0 cdrom=0 removable=1
fi
