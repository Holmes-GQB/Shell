#!/bin/bash
# Program:
#       This script is used to test disk I/O speed.
# History:
#       2017/08/15 Holmes-GQB First release
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

##### variable #####
filename=`date +%s%N | md5sum | head -c 10`
dir=/tmp
size=10	    #The unit is GB

##### checkUser #####
if [ ${UID} -eq 0 ] ; then
    echo "Using root to execute scripts is not a good habit."
    exit 0
fi

##### action #####
time dd of=${dir}/${filename}.dat if=/dev/zero bs=1M count=`echo "1024*${size}" | bc` oflag=direct
wait
time dd if=${dir}/${filename}.dat of=/dev/null bs=1M count=`echo "1024*${size}" | bc` iflag=direct
wait
rm -f ${dir}/${filename}.dat
