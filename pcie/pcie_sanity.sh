#!/bin/sh

. ../include/functions.sh

fgrep pcieport /proc/bus/pci/devices > /dev/null 2>&1
if [ $? -ne 0 ] ; then
    echo "No PCIe port device"
    exit 1
fi

fgrep f_dme_ep /proc/bus/pci/devices > /dev/null 2>&1
if [ $? -ne 0 ] ; then
    echo "No PCIe ep device"
    exit 1
fi

if [ ! -x /usr/bin/lspci ] ; then
    echo 'Unable to execute /usr/bin/lspci'
    exit 1
fi

exit 0
