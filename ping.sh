#!/bin/bash
# Program:
#       This script is used to detects the IP address of LAN activity.
# History:
#       2017/08/09 Holmes-GQB First release
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

for x in `seq 1 254`
    do {
        ping -c 1 192.168.$x.1 > /dev/null 2>&1
        if [ $? -eq 0 ] ; then
            for y in `seq 1 254`
                do {
                    ping -c 1 192.168.$x.$y > /dev/null 2>&1	#When the 192.168.[1-254].1 ping pass, to ping 192.168.[1-254].[1-254]
                    if [ $? -eq 0 ] ; then
                        echo "192.168.$x.$y UP"
                    else
                        echo "192.168.$x.$y DOWN"
                    fi
                }&  #Second Ping operations, background execution
                done
            wait    #Wait until the background check is complete
        else
            echo "192.168.$x.1 DOWN"
        fi
    }&
    done
wait
