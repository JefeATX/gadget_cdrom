#!/bin/bash

# Unload gadget if loaded
if lsmod | grep -q g_mass_storage; then
    rmmod g_mass_storage
fi

# Unmount /iso if mounted
if mountpoint -q /iso; then
    umount /iso
fi

# Detach all loop devices
losetup -D

# Unload cdemu device 0 if loaded
cdemu unload 0 || true
