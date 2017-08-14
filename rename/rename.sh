#!/bin/bash
# Program:
# 	This progarm is using to batch rename.
# history:
# 2017/08/14 Holmes-GQB First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

##### variable ######
old_prefix=Shell
old_suffix=txt
new_prefix=script
new_suffix=py

##### for #####
for i in `ls | egrep "^${old_prefix}.*\.${old_suffix}$"`; do mv $i `echo $i | sed "s/${old_suffix}/${new_suffix}/g"`; done

##### C_rename #####
# syntax: rename parameter1(old_name) parameter2(new_name) parameter3(file)
rename ${old_suffix} ${new_suffix} `ls | egrep "^${old_prefix}.*\.${old_suffix}$"`

##### Perl_rename #####
# syntax: rename parameter1(Perl_regex) parameter2(file)
# Use this command need to comment off ${PATH}, invokes the rename script of the current directory.
./rename "s/\.${old_prefix}$//g" `ls | egrep "^${old_prefix}.*\.${old_suffix}$"`
