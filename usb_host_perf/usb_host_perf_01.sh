#!/bin/bash

source ../include/sh-test-lib
. ../include/filecheck_functions.sh

DISK_NAME=`ls -al /dev/disk/by-id/ | grep usb | head -n 1 | cut -d'/' -f3`
PARTS_NUM=`ls -al /dev/disk/by-id/ | grep usb | wc -l`
PARTS_NAME=`ls -al /dev/disk/by-id/ | grep usb | head -n 2 | tail -n 1 | cut -d'/' -f3`
MOUNT_DIR=/media/usb
SRC_DIR=/tmp/usbtest
DEST_DIR=${MOUNT_DIR}/usbtest

# Check if USB storage is available
check_usb() {
    TEST="check_usb_storage_is_available"
    if [ ! -b /dev/${DISK_NAME} ]; then
        fail_test "Unable to find usb storage"
    fi
}

# Check if USB storage is in rootfs and mount to /media/usb
mount_usb() {
    TEST="mount_usb_storage"
    mkdir ${MOUNT_DIR}
    grep ${DISK_NAME} /proc/cmdline
    if [ ${?} -ne 0 ] ; then
        if [ "${PARTS_NUM}" -lt 2 ] ; then
            fail_test "There is no partitions for mount"
        else
            mount /dev/${PARTS_NAME} ${MOUNT_DIR}
            check_return_fail "Unable to mount usb storage" && return 1
        fi
    fi
}

# Umount /media/usb
umount_usb() {
    TEST="umount_usb_storage_test"
    grep ${MOUNT_DIR} /proc/mounts
    if [ ${?} -eq 0 ] ; then
        umount ${MOUNT_DIR}
        check_return_fail "Umount usb storage fail" && return 1
    fi
}

# USB Write/Read Performance Test
usb_write_read_test() {
    TEST="usb_read_write_test"
    echo "[USB Write/Read Performance Test-HostMode]" >> usb-pf-test_hostmode.log
    #1k block size-wrtie/read test action
    echo "=====1K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=1k count=1048576 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====1K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=1k count=1048576 iflag=direct 2>> usb-pf-test_hostmode.log
    #4k block size-wrtie/read test action
    echo "=====4K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=4k count=262144 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====4K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=4k count=262144 iflag=direct 2>> usb-pf-test_hostmode.log
    #16k block size-wrtie/read test action
    echo "=====16K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=16k count=65536 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====16K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=16k count=65536 iflag=direct 2>> usb-pf-test_hostmode.log
    #32k block size-wrtie/read test action
    echo "=====32K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=32k count=32768 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====32K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=32k count=32768 iflag=direct 2>> usb-pf-test_hostmode.log
    #64k block size-wrtie/read test action
    echo "=====64K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=64k count=16384 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====64K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=64k count=16384 iflag=direct 2>> usb-pf-test_hostmode.log
    #128k block size-wrtie/read test action
    echo "=====128K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=128k count=8192 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====128K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=128k count=8192 iflag=direct 2>> usb-pf-test_hostmode.log
    #256k block size-wrtie/read test action
    echo "=====256K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=256k count=4096 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====256K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=256k count=4096 iflag=direct 2>> usb-pf-test_hostmode.log
    #512k block size-wrtie/read test action
    echo "=====512K Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=512k count=2048 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====512K Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=512k count=2048 iflag=direct 2>> usb-pf-test_hostmode.log
    #1M block size-wrtie/read test action
    echo "=====1M Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=1M count=1024 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====1M Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=1M count=1024 iflag=direct 2>> usb-pf-test_hostmode.log
    #2M block size-wrtie/read test action
    echo "=====2M Block Size-Wrtie Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=/dev/zero of=${MOUNT_DIR}/testfile bs=2M count=512 oflag=direct 2>> usb-pf-test_hostmode.log
    echo "=====2M Block Size-Read Speed Test=====" >> usb-pf-test_hostmode.log
    dd if=${MOUNT_DIR}/testfile of=/dev/zero bs=2M count=512 iflag=direct 2>> usb-pf-test_hostmode.log
    check_return_fail "USB read/write test fail" && return 1
}

# Submit successful result
submit_pass_result() {
    TEST="USB2.0_3.0_Host_Mode_Performance_Test"
    pass_test
}


# Run the tests
check_usb
mount_usb
echo "Start to read and write USB2.0/3.0 storage"
usb_write_read_test
umount_usb
submit_pass_result

# Clean exit so lava-test can trust the results
exit 0
