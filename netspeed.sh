#!/bin/bash
# Program:
#       This script is used to test network speed.
# History:
#       2017/08/10 Holmes-GQB First release
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

##### variable #####
network_card=`ip link | grep "state UP" | tail -1 | awk '{print $2}' | cut -d ':' -f 1`

##### Waiting for user enter number #####
read -p "Please enter the time to be counted in seconds: " -t 30 time

##### Determine whether there is input #####
if [ ! -n "${time}" ] ; then
    echo
    read -p "Please enter the time to be counted in seconds: " -t 30 time
    if [ ! -n "${time}" ] ; then
	echo
	echo "Your do not enter angthing!"
	exit 0
    fi
fi

##### Determine the input whether it is a number #####
if [ ! -n "`echo ${time} | sed 's/[^0-9]//g'`" ] ; then
    read -p "Please enter the number: " -t 10 time
    if [ ! -n "`echo ${time} | sed 's/[^0-9]//g'`" ] ; then
	echo "Enter error!"
	exit 0
    else
	echo "Enter success! Start monitoring..."
    fi
else
    echo "Enter success! Start monitoring..."
fi

##### Start to test network speed #####
time=`echo ${time} | sed 's/[^0-9]//g'`
for i in `seq 1 ${time}`
do
    input1=`cat /sys/class/net/${network_card}/statistics/rx_bytes`
    output1=`cat /sys/class/net/${network_card}/statistics/tx_bytes`
    sleep 1s
    input2=`cat /sys/class/net/${network_card}/statistics/rx_bytes`
    output2=`cat /sys/class/net/${network_card}/statistics/tx_bytes`
    input_size=`expr ${input2} - ${input1}`
    output_size=`expr ${output2} - ${output1}`
    input_speed=`expr ${input_size} / 1024`
    output_speed=`expr ${output_size} / 1024`
    echo "INPUT:${input_speed} KB/s	OUTPUT:${output_speed} KB/s"
done 2>&1 | tee netspeed.txt

##### statistics #####
cat netspeed.txt | awk -F ':| ' '{sum += $2} END{print "input_average:"sum / 1024 / "'"${time}"'","MB/s"}'
cat netspeed.txt | awk -F ':| ' '{sum += $4} END{print "output_average:"sum / 1024 / "'"${time}"'","MB/s"}'
