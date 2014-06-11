#!/bin/sh

. ../include/functions.sh

INTERFACE=eth0
DEFROUTE=`netstat -n -r | grep '^0\.0\.0\.0'`

check_ping() {
    BEG_ERRORS=`ifconfig ${INTERFACE} | fgrep -i errors: | sed -e 's/.*errors:/errors:/'`
    set ${DEFROUTE}
    LOSS=`ping -i 0.001 -q -c 10000 -s 996 ${2} | fgrep -i transmitted | sed -e 's/^.*\([0-9][0-9]*\)%.*/\1/'`
    END_ERRORS=`ifconfig ${INTERFACE} | fgrep -i errors: | sed -e 's/.*errors:/errors:/'`
    if [ "${LOSS}" -ne 0 ] ; then
	return 1
    fi

    if [ "${BEG_ERRORS}" != "${END_ERRORS}" ] ; then
	return 1
    fi
    return 0
}

check "Send a high rate of ICMP echo packets and determine if there are any errors" check_ping

exit 0
