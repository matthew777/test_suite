#!/bin/sh

. ../include/functions.sh

INTERFACE=eth0
GATEWAY=192.168.1.200
DOWNLOAD_FILE=http://192.168.1.75/images/kernel-3.4.tar.gz

check_netstat() {
    echo "netstat -an" >> ethernet.log 2>&1
    netstat -an >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_ifconfig() {
    echo "ifconfig -a" >> ethernet.log 2>&1
    ifconfig -a >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_route() {
    echo "route" >> ethernet.log 2>&1
    route >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_ifconfig_up_lo() {
    ifconfig lo up
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_ifconfig_up() {
    ifconfig $INTERFACE up
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}


check_ifconfig_down() {
    ifconfig $INTERFACE down
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_dhclient() {
    echo "dhclient -v $INTERFACE" >> ethernet.log 2>&1
    dhclient -v $INTERFACE >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_ping() {
    echo "ping -c 5 $GATEWAY" >> ethernet.log 2>&1
    ping -c 5 $GATEWAY >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_apt_get() {
    echo "apt-get update" >> ethernet.log 2>&1
    apt-get update >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_apt_get_wget() {
    echo "apt-get install -q -y wget" >> ethernet.log 2>&1
    apt-get install -q -y wget >> ethernet.log 2>&1
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check_wget_file() {
    wget -q $DOWNLOAD_FILE
    if [ $? -ne 0 ] ; then
	return 1
    fi

    return 0
}

check "Check netstat command" check_netstat
check "Check ifconfig dump" check_ifconfig
check "Check route dump-a" check_route
check "Check route ifconfig up lo" check_ifconfig_up_lo
check "Check route dump-b" check_route
check "Check route ifconfig up interface" check_ifconfig_up
check "Check route ifconfig down interface" check_ifconfig_down
check "Check route dhclient" check_dhclient
check "Check route dump-c" check_route
check "Check ping" check_ping
check "Check apt-get update" check_apt_get
check "Check apt-get install wget" check_apt_get_wget
check "Check wget big fils" check_wget_file

exit 0
