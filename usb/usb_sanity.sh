#!/bin/sh

. ../include/functions.sh
if [ -b /dev/sda ]
  then
    exit 0
  else
    exit 1
fi
