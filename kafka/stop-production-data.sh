#!/bin/bash
# Program:
#       This progarm is using to kill the kafka-production-data.sh process.
# history:
# 2017/08/13 Holmes-GQB First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### kill pid #####
pid=`more kafka-production-data.pid`
kill -15 ${pid}
[ -z `ps -ef | grep ${pid} | grep -v grep` ] && rm -f kafka-production-data.pid
