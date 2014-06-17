#!/bin/sh

. ../include/functions.sh

TEMP=/tmp/sdtest${$}
trap "rm -f ${TEMP} ; exit 1" 1 2 3 15
trap "rm -f ${TEMP}" 0

check_blocks() {
    dd if=/dev/mmcblk1 of=/dev/null bs=256K count=1K > ${TEMP} 2>&1
    IN=`fgrep -i 'records in' ${TEMP} | cut -f1 '-d '`
    if [ -z "${IN}" ] ; then
	return 1
    fi

    COUNT=`echo "${IN}" | cut -f1 -d+`
    if [ "${COUNT}" -lt 1 ] ; then
	return 1
    fi

    if [ fgrep -i error ${TEMP} > /dev/null 2>&1 ] ; then
	return 1
    fi
    return 0
}

check "Read a large amount of data from the SD card and check for errors" check_blocks

exit 0
