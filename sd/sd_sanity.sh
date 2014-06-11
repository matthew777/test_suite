#!/bin/sh

. ../include/functions.sh
if [ -b /dev/mmcblk0 ]
  then
    exit 0
  else
    exit 1
fi
