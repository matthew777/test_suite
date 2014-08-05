#!/bin/sh

. ../include/functions.sh

if [ ! -b /dev/mtdblock2 ]
  then
    echo "Unable to find /dev/mtdblock2"
    exit 1
fi

if [ ! -d /root ]
  then
    echo "No /root directory"
    exit 1
fi

if [ ! -d /tmp ]
  then
    echo "No /tmp directory"
    exit 1
fi

exit 0
