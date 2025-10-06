#!/bin/bash -eu

EXT=${1:-iso}
# Change this to your image directory
IMGDIR="/opt/gadget_cdrom"

find "$IMGDIR" -type f -iname "*.$EXT" -not -path '*/.*' -print0
