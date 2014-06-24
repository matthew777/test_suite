#!/bin/bash

check_test_env(){
    grep -q reboot /etc/init.d/rc.local
    if [ ${?} -ne 0 ] ; then
    echo "./root/reboot.sh" >> /etc/init.d/rc.local
    fi

    test -e /root/num.log
    if [ ${?} -ne 0 ] ; then
    echo 1 > /root/num.log
    fi
}

reboot_test(){
    i=$(cat /root/num.log)
    while [ $i -le 3 ]
    do
        echo "***System Reboot Stablity Test***"
        echo "System will reboot in 10 seconds..."
        echo "<kill -2 $$> Stop rebooting"
        i=$((${i}+1))
        echo $i > /root/num.log
        sync
        trap "sed -i 's/.\/root\/reboot.sh//g' /etc/init.d/rc.local ; exit 1" SIGINT
        sleep 10
        reboot
        exit 1
    done
}

test_result(){
    echo "***System Reboot Stablity Test Result***"
    echo "All Test Pass"
    sed -i 's/.\/root\/reboot.sh//g' /etc/init.d/rc.local
}

#Test_flow
check_test_env
reboot_test
test_result
