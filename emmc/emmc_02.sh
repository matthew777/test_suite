#!/bin/bash

source ../include/sh-test-lib
. ../include/filecheck_functions.sh

DISK_NAME=mmcblk0
#DISK_NAME=`ls -al /dev/disk/by-id/ | grep mmc | head -n 1 | cut -d'/' -f3`
PARTS_NUM=`ls -al /dev/disk/by-id/ | grep ${DISK_NAME} | wc -l`
PARTS_NAME=`ls -al /dev/disk/by-id/ | grep ${DISK_NAME} | head -n 5 | tail -n 1 | cut -d'/' -f3`
MOUNT_DIR=/media/emmc
SRC_DIR=/tmp/emmctest
DEST_DIR=${MOUNT_DIR}/emmctest

# Check if eMMC is available
check_emmc() {
    TEST="check_emmc_is_available"
    if [ ! -b /dev/${DISK_NAME} ]; then
        fail_test "Unable to find emmc"
    fi
}

# Check if eMMC is in rootfs and mount to /media/emmc
mount_emmc() {
    TEST="mount_emmc"
    mkdir ${MOUNT_DIR}
    grep ${DISK_NAME} /proc/cmdline
    if [ ${?} -ne 0 ] ; then
        if [ "${PARTS_NUM}" -lt 2 ] ; then
            fail_test "There is no partitions for mount"
        else
            mount /dev/${PARTS_NAME} ${MOUNT_DIR}
            check_return_fail "Unable to mount emmc" && return 1
        fi
    fi
}

# Copy /tmp/emmctest to /media/emmc
copy_files_test() {
    TEST="copy_files_test"
    cp -r ${SRC_DIR} ${MOUNT_DIR}
    check_return_fail "Copy /tmp/emmctest to /media/emmc fail" && return 1
    sync
}

# Delete /media/emmc/emmctest/
delete_files_test() {
    TEST="delete_files_test"
    rm -r ${DEST_DIR}
    check_return_fail "Delete files fail" && return 1
}

# Umount /media/emmc
umount_emmc() {
    TEST="umount_emmc_test"
    grep ${MOUNT_DIR} /proc/mounts
    if [ ${?} -eq 0 ] ; then
        umount ${MOUNT_DIR}
        check_return_fail "Umount emmc fail" && return 1
    fi
}

# Submit successful result
submit_pass_result() {
    TEST="eMMC_Test"
    pass_test
}


# Run the tests
check_emmc
mount_emmc
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

umount_emmc
submit_pass_result

# Clean exit so lava-test can trust the results
exit 0
