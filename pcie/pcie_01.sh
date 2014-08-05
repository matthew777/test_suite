#!/bin/sh

. ../include/functions.sh

check_lspci() {
    lspci -v >> lspci.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    grep "PCI bridge" lspci.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    grep "RAM memory" lspci.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    return 0
}

check_pcie_host() {
    dmesg | grep "pcie0" >> pcie_host.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    grep "Link Speed 2.5GT/s and 5.0GT/s" pcie_host.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    grep "Link X 4" pcie_host.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    grep "now link speed 2.5GT/s" pcie_host.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    return 0
}

check_pcie_ep() {
    dmesg | grep "pcie1" >> pcie_ep.log 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    grep "Link Speed 2.5GT/s and 5.0GT/s" pcie_ep.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    grep "Max Link X 4" pcie_ep.log > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    return 0
}

check_endpoint_test() {
    dmesg | grep "pcie Endpoint TEST PASS" > /dev/null 2>&1
    if [ $? -ne 0 ] ; then
        return 1
    fi

    return 0
}

check "Check lspci" check_lspci
check "Check pcie host link speed and link width" check_pcie_host
check "Check pcie ep link speed and link width" check_pcie_ep
check "Check pcie endpoint test" check_endpoint_test

exit 0
