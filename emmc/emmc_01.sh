#!/bin/sh

. ../include/functions.sh

check_partitions() {
    N=`grep mmcblk0 /proc/partitions | wc -l`
    if [ "${N}" -lt 2 ] ; then
	return 1
    else
	return 0
    fi
}

check "Verify that we can see at least two partitions on the main eMMC interface" check_partitions

exit 0
