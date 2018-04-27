#!/bin/bash
# Program:
#       这个脚本用来获取天天基金网实时估值。
# History:
#       2018/04/21 Holmes-GQB 第一次发布
#       2018/04/27 Homles-GQB 第一次修改（添加E大浮动盈亏率，添加收集的ETF数据，添加获取不到数据的判断）
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

##### 变量区 #####
date_time=`date "+%Y-%m-%d %H:%M"`
file_dir=../file
log_dir=../logs

##### 函数区 #####
function echolog () {
    echo -e "${date_time} $*" >> ${log_dir}/etf_$(date +%Y%m%d).log
}
function red() {
    echo -e "\033[31;1m${1}\033[0m"
}
function green() {
    echo -e "\033[32;1m${1}\033[0m"
}

##### 动作区 #####
if ls ${file_dir}/*.html > /dev/null 2>&1 ; then
    \rm ${file_dir}/*.html
fi

curl http://fundgz.1234567.com.cn/js/100032.js?rt=1463558676006 > ${file_dir}/100032.html      # 中证红利
curl http://fundgz.1234567.com.cn/js/000478.js?rt=1463558676006 > ${file_dir}/000478.html      # 中证500增强
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
curl http://fundgz.1234567.com.cn/js/000071.js?rt=1463558676006 > ${file_dir}/000071.html      # 恒生
curl http://fundgz.1234567.com.cn/js/162411.js?rt=1463558676006 > ${file_dir}/162411.html      # 华宝油气
curl http://fundgz.1234567.com.cn/js/160416.js?rt=1463558676006 > ${file_dir}/160416.html      # 石油基金
curl http://fundgz.1234567.com.cn/js/000614.js?rt=1463558676006 > ${file_dir}/000614.html      # 德国DAX
curl http://fundgz.1234567.com.cn/js/003376.js?rt=1463558676006 > ${file_dir}/003376.html      # 7-10国开债
curl http://fundgz.1234567.com.cn/js/050027.js?rt=1463558676006 > ${file_dir}/050027.html      # 博时信用债
curl http://fundgz.1234567.com.cn/js/270048.js?rt=1463558676006 > ${file_dir}/270048.html      # 广发纯债
curl http://fundgz.1234567.com.cn/js/001061.js?rt=1463558676006 > ${file_dir}/001061.html      # 华夏海外收益债
curl http://fundgz.1234567.com.cn/js/000216.js?rt=1463558676006 > ${file_dir}/000216.html      # 黄金

cd ${file_dir}
for file in 100032.html 000478.html 001064.html 000968.html 001180.html 004752.html 001052.html 502010.html 110026.html 003765.html 000051.html 001051.html 000071.html 162411.html 160416.html 000614.html 003376.html 050027.html 270048.html 001061.html 000216.html
do
    value1=`grep -Po '(?<=gsz":")[0-9.]*(?=",)' ${file}`                                                                    # 净值估算
    range1=`grep -Po '(?<=gszzl":")[-+.0-9]*(?=",)' ${file}`                                                                # 涨幅估算
    symbol=`echo ${range1} | grep -o '[+-]'`                                                                                # 判断涨跌
    etf_name=`cat /data/etf/file/list.txt | grep -Po "(?<=${file%.*},)[^,]*"`                                               # 根据列表获取名称
    e_value=`cat /data/etf/file/list.txt | awk -F ',' '/'${file%.*}'/{print $3}'`                                           # 根据列表获取E大当前净值
    rate1=`awk 'BEGIN { rate=('${value1}'-'${e_value}')/'${e_value}*100' ; print rate }' | grep -Po '\-?[0-9]+\.[0-9]{2}'`  # 浮动盈亏率
    if [ -z ${value1} ] || [ -z ${range1} ] ; then
        echolog "[${etf_name}]\t\033[33;1m获取不到数据! \033[0m"
        continue
    fi
    if [[ "X${symbol}" == "X" ]] ; then
        range2=`red +${range1}`
        if [[ ${value1} > ${e_value} ]] ; then
            value2=`red ${value1}`
            rate2=`red +${rate1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}% ; E大浮动盈亏率为: ${rate2}%"
        elif [[ ${value1} < ${e_value} ]] ; then
            value2=`green ${value1}`
            rate2=`green ${rate1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}% ; E大浮动盈亏率为: ${rate2}%"
        else
            echolog "[${etf_name}]\t净值估算为: ${value1} ; 估算涨幅为: ${range2}% ; E大浮动盈亏率为: ${rate1}%"
        fi
    elif [[ "X${symbol}" == "X-" ]] ; then
        range2=`green ${range1}`
        if [[ ${value1} > ${e_value} ]] ; then
            value2=`red ${value1}`
            rate2=`red +${rate1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}% ; E大浮动盈亏率为: ${rate2}%"
        elif [[ ${value1} < ${e_value} ]] ; then
            value2=`green ${value1}`
            rate2=`green ${rate1}`
            echolog "[${etf_name}]\t净值估算为: ${value2} ; 估算涨幅为: ${range2}% ; E大浮动盈亏率为: ${rate2}%"
        else
            echolog "[${etf_name}]\t净值估算为: ${value1} ; 估算涨幅为: ${range2}% ; E大浮动盈亏率为: ${rate1}%"
        fi
    else
        echolog "涨幅判断有问题！"
        exit 1
    fi
done
echolog "-------------------- 万恶的分隔线 --------------------"
