#!/bin/bash

source ../include/sh-test-lib
. ../include/filecheck_functions.sh

DISK_NAME=mmcblk1
#DISK_NAME=`ls -al /dev/disk/by-id/ | grep mmc | head -n 1 | cut -d'/' -f3`
PARTS_NUM=`ls -al /dev/disk/by-id/ | grep ${DISK_NAME} | wc -l`
PARTS_NAME=`ls -al /dev/disk/by-id/ | grep ${DISK_NAME} | head -n 2 | tail -n 1 | cut -d'/' -f3`
MOUNT_DIR=/media/sdcard
SRC_DIR=/tmp/sdtest
DEST_DIR=${MOUNT_DIR}/sdtest

# Check if SD card is available
check_sd_card() {
    TEST="check_sd_card_is_available"
    if [ ! -b /dev/${DISK_NAME} ]; then
        fail_test "Unable to find sd card"
    fi
}

# Check if SD card is in rootfs and mount to /media/sdcard
mount_sd_card() {
    TEST="mount_sd_card"
    mkdir ${MOUNT_DIR}
    grep ${DISK_NAME} /proc/cmdline
    if [ ${?} -ne 0 ] ; then
        if [ "${PARTS_NUM}" -lt 2 ] ; then
            fail_test "There is no partitions for mount"
        else
            mount /dev/${PARTS_NAME} ${MOUNT_DIR}
            check_return_fail "Unable to mount sd card" && return 1
        fi
    fi
}

# Copy /tmp/sdtest to /media/sdcard
copy_files_test() {
    TEST="copy_files_test"
    cp -r ${SRC_DIR} ${MOUNT_DIR}
    check_return_fail "Copy /tmp/sdtest to /media/sdcard fail" && return 1
    sync
}

# Delete /media/sdcard/sdtest/
delete_files_test() {
    TEST="delete_files_test"
    rm -r ${DEST_DIR}
    check_return_fail "Delete files fail" && return 1
}

# Umount /media/sdcard
umount_sdcard() {
    TEST="umount_sdcard_test"
    grep ${MOUNT_DIR} /proc/mounts
    if [ ${?} -eq 0 ] ; then
        umount ${MOUNT_DIR}
        check_return_fail "Umount sdcard fail" && return 1
    fi
}

# Submit successful result
submit_pass_result() {
    TEST="SD_Card_Test"
    pass_test
}


# Run the tests
check_sd_card
mount_sd_card
echo "Start to create test files"
create_files ${SRC_DIR}

COUNT=1
while [ $COUNT -le 20 ]
do
    echo "Start to copy and verify files test$COUNT"
    copy_files_test
    verify_files ${SRC_DIR} ${DEST_DIR}
    delete_files_test
    COUNT=$(($COUNT+1))
done

umount_sdcard
submit_pass_result

# Clean exit so lava-test can trust the results
exit 0
