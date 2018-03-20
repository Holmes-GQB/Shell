#!/bin/bash
# Program:
#       This script is used to backup database.
# History:
#       2018/03/17 rebelsre First release
#       2018/03/18 rebelsre First modify (Add export directory to determine.)
#       2018/03/20 rebelsre Second modify (Bug to repair log printing time.)
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

##### variable #####
date_day=`date +%Y%m%d`
backup_dir=/data/backup/mysql
database_name=wordpress
compress_format=bz2

##### function #####
function echolog() {
    echo -e "$(date +%Y%m%d%H%M%S)_${database_name}: ${*} " 2>&1 | tee -a /data/logs/backup_wp_database.log
}
function check_dir() {
    [ -d ${backup_dir}/${database_name}_${date_day} ] || mkdir -p ${backup_dir}/${database_name}_${date_day}
    chown mysql:mysql ${backup_dir}/${database_name}_${date_day}
    if [ "X$(ls -ld ${backup_dir}/${database_name}_${date_day} | awk '{print $3,$4}')" = "Xmysql mysql" ] ; then
        echolog "创建备份目录成功。"
    else
        echolog "创建备份目录失败！"
        exit 1
    fi
}
function check_export() {
    export_dir=$(mysql -uroot -p`cat /data/save/mysql_root` -e "show global variables like '%secure%';" 2>/dev/null | grep 'secure_file_priv' | awk '{print $2}')
    if [ "X${export_dir}" = "XNULL" ] ; then
        echolog "MySQL 不支持导出数据，请检查 --secure-file-priv 参数！"
        exit 1
    elif [ "X${export_dir}" = "X" ] ; then
        export_dir=${backup_dir}/${database_name}_${date_day}
    fi
    if [ -z ${export_dir} ] ; then
        echolog "导出数据目录有问题！"
        exit 1
    else
        echolog "导出数据目录准备完毕。"
    fi
}
function backup_database() {
    if mysql -uroot -p`cat /data/save/mysql_root` -e "use ${database_name};"  >/dev/null 2>&1 ; then
        if
            mysqldump -uroot -p`cat /data/save/mysql_root` -d ${database_name} > ${backup_dir}/${database_name}_${date_day}/${database_name}_structure.sql
            mysqldump -uroot -p`cat /data/save/mysql_root` --single-transaction -T ${export_dir} ${database_name}
            [ `ls ${backup_dir}/${database_name}_${date_day} | grep 'wp_*' | wc -l` -eq 0 ] && mv ${export_dir}/wp_* ${backup_dir}/${database_name}_${date_day} # 这一句中的 grep 部分需要根据实际情况修改
        then
            echolog "备份数据库成功。"
        else
            echolog "备份数据库失败。"
            exit 1
        fi
    else
        echolog "数据库不存在！"
        exit 1
    fi
}
function check_tar() {
    if tar -tf ${backup_dir}/${database_name}_${date_day}.tar.${compress_format} > /dev/null ; then
        chown mysql:mysql ${backup_dir}/${database_name}_${date_day}.tar.${compress_format}
        \rm -rf ${backup_dir}/${database_name}_${date_day}
        echolog "打包压缩成功。"
    else
        echolog "打包压缩失败！"
        exit 1
    fi
}

##### action #####
[ -d /data/logs ] || mkdir -p /data/logs
check_dir
check_export
backup_database
cd ${backup_dir} && tar -acf ${database_name}_${date_day}.tar.${compress_format} ${database_name}_${date_day}
check_tar
