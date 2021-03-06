#!/bin/sh

. ../include/functions.sh

check_mtd2_device() {
    cat /proc/mtd | grep -q mtd2
    if [ ${?} -ne 0 ] ; then
        return 1
    else
        return 0
    fi
}

create_testfile() {
    dd if=/dev/urandom of=/root/testfile bs=512 count=4096
    if [ ${?} -ne 0 ] ; then
        return 1
    else
        return 0
    fi
}

write_hsspi() {
    dd if=/root/testfile of=/dev/mtdblock2
    if [ ${?} -ne 0 ] ; then
        return 1
    else
        return 0
    fi
}

read_hsspi() {
    dd if=/dev/mtdblock2 of=/tmp/dump bs=512 count=4096
    if [ ${?} -ne 0 ] ; then
        return 1
    else
        return 0
    fi
}

cmp_file() {
    cmp /root/testfile /tmp/dump
    if [ ${?} -ne 0 ] ; then
        return 1
    else
        return 0
    fi
}

check "Verify that mtd2 device exists" check_mtd2_device
check "Verify that testfile successfully creates" create_testfile
check "Verify that testfile successfully writes to HSSPI" write_hsspi
check "Verify that file successfully reads from HSSPI" read_hsspi
check "Verify that testfile and readed file are the same" cmp_file

exit 0
