#!/bin/bash
# Program:
# 	This progarm is using to clean the recycle bin.
# history:
#	2017/08/20 Holmes-GQB First release
# Usage: 
#	Join in crontab, for example: (Please change <path> to the absolute path of the script.)
#	0 0 * * * /bin/bash <path>/crontab.sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### variable #####
size=2	    #When space takes more than this value, clean up (Unit for GB)
space=`du -sk /tmp/recycle | awk '{print $1}'`
conversion_unit=`echo "1024*1024*${size}" | bc`

if [ "${space}" -gt "${conversion_unit}" ] ; then
    find /tmp/recycle -mindepth 2 -atime +7 -path "/tmp/recycle/$(whoami)/.history" -prune -o -exec \rm -rf {} \; > /dev/null 2>&1 &
    echo "Cleaning the recycle bin..."
else
    echo "The recycle bin does not need to be cleaned."
    exit 0
fi
