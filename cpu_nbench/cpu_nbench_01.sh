#!/bin/bash

. ../include/functions.sh

NBENCH_SRC=$HOME/nbench

download_src() {
    trap "rmdir ${NBENCH_SRC} ; exit 1" exit INT HUP
    mkdir ${NBENCH_SRC}
    if [ ${?} -ne 0 ] ; then
        echo "Unable to mkdir ${NBENCH_SRC}"
        return 1
    fi

    trap "rmdir ${NBENCH_SRC} ; exit 1" exit INT HUP
    cd ${NBENCH_SRC}
    if [ ${?} -ne 0 ] ; then
        echo "Unable to chdir to ${NBENCH_SRC}"
        return 1
    fi

    trap "cd ; rmdir ${NBENCH_SRC} ; exit 1" INT HUP
    trap - exit
    rm -rf nbenchsrc
    mkdir nbenchsrc && cd nbenchsrc && \
    wget --no-verbose -O - \
        "http://www.tux.org/~mayer/linux/nbench-byte-2.2.3.tar.gz" \
        | tar xzf -
    DOWNLOAD_STATUS=${?}

    return ${DOWNLOAD_STATUS}
}

build_nbench() {
    ( cd nbench-* && make ) > buildlog 2>&1
    tail -5 buildlog | grep -q 'nbench'
    BUILD_STATUS=${?}

    if [ ${BUILD_STATUS} -ne 0 ] ; then
        tail -20 buildlog
    fi

    return ${BUILD_STATUS}
}

run_nbekch() {
    ( cd nbench-* && ./nbench ) > nbench.log 2>&1
    RUN_STATUS=${?}

    if [ ${RUN_STATUS} -ne 0 ] ; then
        tail -20 nbench.log
    fi

    return ${RUN_STATUS}
}

check "Check that the nbench source succesfully downloads" download_src
check "Check that the nbench source succesfully builds" build_nbench
check "Execute nbench test program" run_nbekch
echo "Check test log file at ${NBENCH_SRC}/nbenchsrc"

exit 0
