#!/bin/sh

if [ ! -x /usr/bin/tail ]
  then
    echo 'Unable to execute /usr/bin/tail'
    exit 1
fi
if [ ! -x /usr/bin/wget ]
  then
    echo 'Unable to execute /usr/bin/wget'
    exit 1
fi
if [ ! -x /usr/bin/make ]
  then
    echo 'Unable to execute /usr/bin/make'
    exit 1
fi

exit 0
