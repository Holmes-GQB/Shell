#!/bin/bash
# Program:
#       This progarm is using to producer kafka messages.
# history:
# 2017/08/13 Holmes-GQB First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### variable #####
kafka_ip=localhost
port=9092
topic=test
producer_script_path=/usr/local/kafka_2.11-0.11.0.1/bin/kafka-console-producer.sh
#key_path=
data="This is a test message."

##### producer data #####
while [ 1 ] 
do
#echo ${data} | sh ${producer_script_path} --broker-list ${kafka_ip}:${port} --topic ${topic} --compression-codec snappy --producer.config ${key_path}
echo ${data} | sh ${producer_script_path} --broker-list ${kafka_ip1}:${port} --topic ${topic} 
sleep 1s
done 2>&1 &

##### get the process number #####
echo $! > kafka-production-data.pid
