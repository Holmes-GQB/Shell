#!/bin/bash
# Program:
#       This progarm is using to record Kafka consumption.
# Explain:
#	Add this script to crontab, let it be executed hourly.
#	Such as: 0 */1 * * * /bin/bash /<path>/record-kafka-consumption.sh
# history:
# 2017/07/04 Holmes-GQB First release
# 2017/07/05 Holmes-GQB Second modify (Add archiving function)
# 2017/08/09 Holmes-GQB Third modify (Functional verification and description)
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### Custom Variable #####
date1=`date +%Y%m`
date2=`date +%Y%m%d`
date3=`date +%Y%m%d%H`
date4=`date +%Y%m%d -d "1 days ago"`
date5=`date +%Y%m%d%H -d "1 hours ago"`
kafka_ip=localhost
zk_port=2181
kafka_groupid=test
kafka_path=/usr/local/kafka_2.11-0.11.0.1
producer_script_path=${kafka_path}/bin/kafka-run-class.sh
log_path=/data/kafkalog

##### create directory #####
[ -d ${log_path} ] || mkdir -p ${log_path}
[ -d ${log_path}/${date1} ] || mkdir -p ${log_path}/${date1}
[ -d ${log_path}/${date1}/${date4} ] || mkdir -p ${log_path}/${date1}/${date4}
[ -d ${log_path}/${date1}/${date2} ] || mkdir -p ${log_path}/${date1}/${date2}

##### check consumption Kafka situation #####
sh ${producer_script_path} kafka.tools.ConsumerOffsetChecker --zookeeper ${kafka_ip}:${zk_port} --group ${kafka_groupid} > ${log_path}/kafka-${kafka_groupid}-${date3}.log 2>&1 &

##### compression #####
bzip2 -9 ${log_path}/kafka-backlog-*-${date5}.log > /dev/null 2>&1 &

##### transfer file #####
find ${log_path} -maxdepth 1 -type f -name "*${date4}*.bz2" -exec mv {} ${log_path}/${date1}/${date4} \; > /dev/null 2>&1 &
