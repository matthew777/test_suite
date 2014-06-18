#!/bin/sh

. ../include/functions.sh

DISK_NAME=`ls -al /dev/disk/by-id/ | grep usb | head -n 1 | cut -d'/' -f3`
if [ -b /dev/${DISK_NAME} ]
  then
    exit 0
  else
    exit 1
fi
