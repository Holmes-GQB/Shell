#!/bin/bash
for x in `seq 1 254`
    do {
        ping -c 1 192.168.$x.1 > /dev/null 2>&1
        if [ $? -eq 0 ] ; then
            for y in `seq 1 254`
                do {
                    ping -c 1 192.168.$x.$y > /dev/null 2>&1
                    if [ $? -eq 0 ] ; then
                        echo "192.168.$x.$y UP"
                    else
                        echo "192.168.$x.$y DOWN"
                    fi
                }&
                done
            wait
        else
            echo "192.168.$x.1 DOWN"
        fi
    }&
    done
wait
