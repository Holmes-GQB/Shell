#!/bin/bash

date_time=`date "+%Y-%m-%d %H:%M"`

file_dir=/data/etf/file
log_dir=/data/etf/logs

function echolog () {
    echo -e "${date_time} $*" >> ${log_dir}/etf_$(date +%Y%m%d).log
}
function red() {
    echo -e "\033[31;1m${1}\033[0m"
}
function green() {
    echo -e "\033[32;1m${1}\033[0m"
}

if ls ${file_dir}/*.html > /dev/null 2>&1 ; then
    \rm ${file_dir}/*.html
fi

curl http://fundgz.1234567.com.cn/js/100032.js?rt=1463558676006 > ${file_dir}/100032.html      # 中证红利
curl http://fundgz.1234567.com.cn/js/000478.js?rt=1463558676006 > ${file_dir}/000478.html      # 建信500
curl http://fundgz.1234567.com.cn/js/001064.js?rt=1463558676006 > ${file_dir}/001064.html      # 中证环保
curl http://fundgz.1234567.com.cn/js/000968.js?rt=1463558676006 > ${file_dir}/000968.html      # 养老产业
curl http://fundgz.1234567.com.cn/js/001180.js?rt=1463558676006 > ${file_dir}/001180.html      # 广发医药
curl http://fundgz.1234567.com.cn/js/004752.js?rt=1463558676006 > ${file_dir}/004752.html      # 中证传媒
curl http://fundgz.1234567.com.cn/js/001052.js?rt=1463558676006 > ${file_dir}/001052.html      # 中证500
curl http://fundgz.1234567.com.cn/js/502010.js?rt=1463558676006 > ${file_dir}/502010.html      # 证券公司
curl http://fundgz.1234567.com.cn/js/110026.js?rt=1463558676006 > ${file_dir}/110026.html      # 创业板指
curl http://fundgz.1234567.com.cn/js/003765.js?rt=1463558676006 > ${file_dir}/003765.html      # 广发创业板
curl http://fundgz.1234567.com.cn/js/000051.js?rt=1463558676006 > ${file_dir}/000051.html      # 泸深300
curl http://fundgz.1234567.com.cn/js/001051.js?rt=1463558676006 > ${file_dir}/001051.html      # 上证50

cd ${file_dir}
for file in 100032.html 000478.html 001064.html 000968.html 001180.html 004752.html 001052.html 502010.html 110026.html 003765.html 000051.html 001051.html
do
    value1=`grep -Po '(?<=gsz":")[0-9.]*(?=",)' ${file}`                            # 净值估算
    range1=`grep -Po '(?<=gszzl":")[-+.0-9]*(?=",)' ${file}`                        # 涨幅估算
    symbol=`echo ${range1} | grep -o '[+-]'`                                        # 判断涨跌
    etf_name=`cat /data/etf/file/list.txt | grep -Po "(?<=${file%.*},)[^,]*"`       # 根据列表获取名称
    e_value=`cat /data/etf/file/list.txt | awk -F ',' '/'${file%.*}'/{print $3}'`   # 根据列表获取E大当前净值
    if [[ "X${symbol}" == "X+" ]] ; then
        range2=`red ${range1}`
        if [[ ${value1} > ${e_value} ]] ; then
            value2=`red ${value1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}%"
        elif [[ ${value1} < ${e_value} ]] ; then
            value2=`green ${value1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}%"
        else
            echolog "[${etf_name}]\t净值估算为: ${value1} ; 估算涨幅为: ${range2}%"
        fi
    elif [[ "X${symbol}" == "X-" ]] ; then
        range2=`green ${range1}`
        if [[ ${value1} > ${e_value} ]] ; then
            value2=`red ${value1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}%"
        elif [[ ${value1} < ${e_value} ]] ; then
            value2=`green ${value1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}%"
        else
            echolog "[${etf_name}]\t净值估算为: ${value1} ; 估算涨幅为: ${range2}%"
        fi
    else
        echolog "[${etf_name}]\t净值估算为: ${value1} ; 估算涨幅为: ${range1}%"
    fi
done
echolog "-------------------- 万恶的分隔线 --------------------"
