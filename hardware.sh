#!/bin/bash
# Program:
#       This script is used to Hardware detection.
# History:
#       2017/05/02 Holmes-GQB First release(Create script)
#       2017/08/08 Holmes-GQB Second modify(1.Add function of 'diskUsage'; 2.Improved output; 3.Delete function of networkModel; 4.Add judgement function)
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

##### variable #####
network_card=`ip link | egrep "state UP" | tail -1 | awk '{print $2}' | cut -d ':' -f 1`

##### function #####
dateTime() {
    date +%Y-%m-%d\ %H:%M:%S
}
CPUModel() {
    cat /proc/cpuinfo | egrep "name" | cut -f2 -d: | uniq -c | awk -F '     ' '{print $2}'
}
memorySize() {
    free -m | egrep 'Mem|Swap' | awk '{print $1,$2"MB"}'
}
memoryFrequency() {
    dmidecode | egrep -A16 'Memory Device' | egrep 'Speed' | egrep -v Unknown | uniq | awk '{print $1,$2,$3}'
}
diskSize() {
    lsblk | egrep 'NAME|disk' | awk '{print $1,$4}'
}
diskUsage() {
    df -h | egrep -v 'tmpfs'
}
networkSpeed() {
    [ `command -v ethtool` ] && ethtool ${network_card} | egrep "Speed" | awk '{print $1,$2}' 
}
systemVersion() {
    cat /etc/redhat-release
}
systemBits() {
    getconf LONG_BIT
}
systemKernel() {
    uname -r
}

##### action #####
if [ ${UID} -eq 0 ] ; then
    echo "##### date #####"
    dateTime
    echo -e "\r"
    echo "##### CPU #####"
    CPUModel
    echo -e "\r"
    echo "##### memory #####"
    memorySize
    memoryFrequency
    echo -e "\r"
    echo "##### disk #####"
    diskSize
    echo -e "\r"
    diskUsage
    echo -e "\r"
    if [ ! `command -v ethtool` ] ; then
	yum install ethtool -y >/dev/null 2>&1
	[ `command -v ethtool` ] && echo "ethtool install success."
        echo "##### network #####"
	ethtool ${network_card} | egrep "Speed" | awk '{print $1,$2}'
        echo -e "\r"
    else
	echo "##### network #####"
	networkSpeed
	echo -e "\r"
    fi
    echo "##### system #####"
    echo "System version: `systemVersion`"
    echo "Operating system bit: `systemBits`"
    echo "Kernel version: `systemKernel`"
else
    echo "##### date #####"
    dateTime
    echo -e "\r"
    echo "##### CPU #####"
    CPUModel
    echo -e "\r"
    echo "##### memory #####"
    memorySize
    echo -e "\r"
    echo "##### disk #####"
    diskSize
    echo -e "\r"
    diskUsage
    echo -e "\r"
    if [ `command -v ethtool` ] ; then
	echo "##### network #####"
	networkSpeed 2>/dev/null
	echo -e "\r"
    fi
    echo "##### system #####"
    echo "System version: `systemVersion`"
    echo "Operating system bit: `systemBits`"
    echo "Kernel version: `systemKernel`"
fi
