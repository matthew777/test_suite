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

# Copy /tmp/usbtest to /media/usb
copy_files_test() {
    TEST="copy_files_test"
    cp -r ${SRC_DIR} ${MOUNT_DIR}
    check_return_fail "Copy /tmp/usbtest to /media/usb fail" && return 1
    sync
}

# Delete /media/usb/usbtest/
delete_files_test() {
    TEST="delete_files_test"
    rm -r ${DEST_DIR}
    check_return_fail "Delete files fail" && return 1
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

# Submit successful result
submit_pass_result() {
    TEST="USB_Storage_Test"
    pass_test
}


# Run the tests
check_usb
mount_usb
echo "Start to create test files"
create_files ${SRC_DIR}

COUNT=1
while [ $COUNT -le 3 ]
do
    echo "Start to copy and verify files test$COUNT"
    copy_files_test
    verify_files ${SRC_DIR} ${DEST_DIR}
    delete_files_test
    COUNT=$(($COUNT+1))
done

umount_usb
submit_pass_result

# Clean exit so lava-test can trust the results
exit 0
