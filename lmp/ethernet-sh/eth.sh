#!/bin/bash

#source sh-test-lib function
source include/sh-test-lib

#whileloop
typeset -i value=1;
while [ $value -le 100 ] ; do

	TEST="Connect Ethernet/SATA and Ping internal IP Address"

	#Connect Ethernet/SATA
	echo -e -n "\x02{\"schema\":\"org.linaro.lmp.sata\", \"serial\":\"LL19LL0000000000\",\"modes\":[{\"name\":\"sata\", \"option\":\"passthru\"}]}\x04" > /dev/ttyACM0

	#wait 20sec
	sleep 20

	#Ping internal IP address 5 times, and Check expect result is Pass
	ping -c 5 192.168.1.150

	#
	if [ ${?} != 0 ]; then
        	fail_test "Ping internal IP address failed"
        	return 1
	else
		pass_test
	fi

	TEST="Disconnect Ethernet/SATA and Check Ping internal IP Address function is Disable"
	#Disconnect Ethernet/SATA
	echo -e -n "\x02{\"schema\":\"org.linaro.lmp.sata\", \"serial\":\"LL19LL0000000000\",\"modes\":[{\"name\":\"sata\", \"option\":\"disconnect\"}]}\x04" > /dev/ttyACM0

	#Wait 20sec
	sleep 20

	#Ping internal IP address 5 times, and Check expect result is Failed
	ping -c 5 192.168.1.150

	#
        if [ ${?} != 1 ]; then
                fail_test "Abnormal ethernet behavior"
                return 1
        else
                pass_test
        fi

	value=value+1
done
