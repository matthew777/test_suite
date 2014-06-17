#!/bin/bash

. ../include/functions.sh

KERNEL_SRC=/tmp/kernelsrc.${$}

download_src() {
    trap "rmdir ${KERNEL_SRC} ; exit 1" exit INT HUP
    mkdir ${KERNEL_SRC}
    if [ ${?} -ne 0 ] ; then
        echo "Unable to mkdir ${KERNEL_SRC}"
        return 1
    fi

    trap "rmdir ${KERNEL_SRC} ; exit 1" exit INT HUP
    cd ${KERNEL_SRC}
    if [ ${?} -ne 0 ] ; then
        echo "Unable to chdir to ${KERNEL_SRC}"
        return 1
    fi

    trap "cd ; rmdir ${KERNEL_SRC} ; exit 1" INT HUP
    trap - exit
    rm -rf kernelsrc
    mkdir kernelsrc && cd kernelsrc && \
    wget --no-verbose -O - \
        "http://172.16.34.199/images/kernel-3.4.tar.gz" \
        | tar xzf -
    DOWNLOAD_STATUS=${?}

    return ${DOWNLOAD_STATUS}
}

build_kernel() {
    ( cd kernel-* && make distclean && make omap2plus_defconfig && make -j2 uImage ) > buildlog 2>&1
    tail -9 buildlog | grep -q 'arch/arm/boot/uImage is ready'
    BUILD_STATUS=${?}

    if [ ${BUILD_STATUS} -ne 0 ] ; then
        tail -50 buildlog
    fi

    return ${BUILD_STATUS}
}

check "Check that the kernel source succesfully downloads" download_src
COUNT=1
while [ $COUNT -le 5 ]
do
    echo "Start to build kernel source test$COUNT"
    check "Verify that the kernel succesfully builds" build_kernel
    COUNT=$(($COUNT+1))
done

exit 0
