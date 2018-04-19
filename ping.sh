#!/bin/bash
# 脚本说明:
#       这个脚本用来检测 Class C 网络中活动的 IP 地址。
# 修改历史:
#       2017/08/09 Holmes-GQB 第一次发布
#       2018/04/19 Holmes-GQB 第一次修改: 修改 ping timeout 时间为1s，优化程序运行时间。
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

for x in `seq 1 254`
do {
    if ping -c 1 -W 1 192.168.$x.1 > /dev/null 2>&1 ; then
        for y in `seq 1 254`
        do {
            if ping -c 1 -W 1 192.168.$x.$y > /dev/null 2>&1 ; then     # 当 192.168.$x.1 存活时，ping 192.168.$x.$y
                echo "192.168.$x.$y UP"
            else
                echo "192.168.$x.$y DOWN"
            fi
        }&  # 后台执行
        done
        wait    # 等待后台的 ping 程序跑完
    else
        echo "192.168.$x.1 DOWN"
    fi
}&
done
wait
