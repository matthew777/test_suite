#!/bin/sh

. ../include/functions.sh

INTERFACE=eth0

fgrep $INTERFACE: /proc/net/dev > /dev/null 2>&1
exit $?
