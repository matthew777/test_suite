#!/bin/bash

#whileloop
typeset -i value=1;
while [ $value -le 5 ] ; do
	
	#print connect message
	echo "Connect to the HDMI Device...Please Check the HDMI Device screen is displayed"

	#Connect the HDMI Device
	echo -e -n "\x02{\"schema\":\"org.linaro.lmp.hdmi\", \"serial\":\"LL0c000013060021\",\"modes\":[{\"name\":\"hdmi\", \"option\":\"passthru\"}]}\x04" > /dev/ttyACM0

	#wait 10sec
	sleep 10

	#print disconnect message
	echo "Disconnect the HDMI Device...Please Check the HDMI Device screen is blank"

	#Disconnect Ethernet/SATA
	echo -e -n "\x02{\"schema\":\"org.linaro.lmp.hdmi\", \"serial\":\"LL0c000013060021\",\"modes\":[{\"name\":\"hdmi\", \"option\":\"disconnect\"}]}\x04" > /dev/ttyACM0

	#Wait 10sec
	sleep 10

	value=value+1
done
