#!/bin/sh

. ../include/functions.sh

fgrep eth0: /proc/net/dev > /dev/null 2>&1
exit $?
