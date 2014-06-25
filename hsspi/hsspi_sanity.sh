#!/bin/sh

. ../include/functions.sh

if [ -b /dev/mtdblock1 ]
  then
    exit 0
  else
    exit 1
fi

if [ -d /root ]
  then
    exit 0
  else
    exit 1
fi

if [ -d /tmp ]
  then
    exit 0
  else
    exit 1
fi
