#!/bin/bash

# Create files
function create_files() {
    TEST="create_tested_files"
    local SRC_DIR=$1
    local FILESIZE=2048
    local FILE_AMOUNT=500
    local NUM=0

    mkdir ${SRC_DIR}

    while [ ${NUM} -lt ${FILE_AMOUNT} ]
    do
        dd if=/dev/urandom of=${SRC_DIR}/file`printf "%04d" "${NUM}"` bs=1024 count=$(($RANDOM%${FILESIZE}+1))
        check_return_fail "Create tested files fail" && return 1
        NUM=$((${NUM}+1))
    done

    dd if=/dev/urandom of=${SRC_DIR}/file`printf "%04d" "${NUM}"` bs=1024 count=1048576
    check_return_fail "Create tested files fail" && return 1
}

# Verify SRC_FILES and DEST_FILES
function verify_files() {
    TEST="verify_files_test"
    local SRC_FILES=$1
    local DEST_FILES=$2
    local AMOUNT=`find ${SRC_FILES} -type f | wc -l`
    local COUNT=0
    while [ ${COUNT} -lt ${AMOUNT} ]
    do
        TEST_FILE=file`printf "%04d" "${COUNT}"`
        cmp ${SRC_FILES}/${TEST_FILE} ${DEST_FILES}/${TEST_FILE}
        check_return_fail "verity ${TEST_FILE} fail" && return 1
        COUNT=$((${COUNT}+1))
    done
}
