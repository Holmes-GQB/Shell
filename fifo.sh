#!/bin/bash

process_number=$1   # 并行数
tempfifo=$$.fifo    # 管道临时文件

if [[ -z $1 ]] ; then
    echo "请使用：sh $0 并行数"
    exit 1
fi

trap "exec 1000>&- ; exec 1000<&- ; exit 0" 2   # trap命令：当Shell收到指定信号（2表示Ctrl+c）执行""中的命令
mkfifo ${tempfifo}  # 创建管道文件
exec 1000<>${tempfifo}  # 将文件描述符1000与管道文件进行绑定，<读的绑定，>写的绑定，<>则表示对文件描述符1000的所有操作等同于对管道文件的操作
rm -f ${tempfifo}   # 删除管道文件。注：管道的一个重要特性，就是读写必须同时存在，缺失某一个操作，另一个操作就是滞留

# 通过循环对文件描述符1000写入空行（管道文件的读取，是以行为单位的），这个${process_number}就是要定义的后台并发的线程数
for ((i=0; i<=${process_number}; i++))
do
    echo >&1000
done

for ((i=0; i<10; i++))
do
    read -u1000 # 读取管道中的一行
    {
        echo "success${i}" ; sleep 3s
        echo >&1000 # 写入管道中的一行
    }&  # 后台执行
done

wait    # 等待后台进程结束

exec 1000>&-    # 表示关闭文件描述符1000的写
exec 1000<&-    # 表示关闭文件描述符1000的读
