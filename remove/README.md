##回收站
<font color=red size=5>写在最前：请使用者自行验证签名文件和测试脚本功能，脚本涉及到的权限较高，如果不小心删除重要文件请后果自负！如有疑问也可与我联系。</font>
###一、用途：在Linux上实现window的回收站功能。
###二、文件说明：
####rm：
**1、实现功能：**
a、检测回收站是否存在，如果不存在会创建回收站；（个人用户看不到别人的回收站目录，和/home类似）
b、使用rm命令时不是直接删除文件，而是先备份到回收站，并做记录，然后在删除文件；
c、对要rm的文件有大小的判断机制，默认超过2G的文件是直接删除（有交互式的提醒），不做备份，不做记录。

**2、脚本用法：**
该脚本用来替换Linux的rm命令，让使用者在敲rm命令时能够调用这个脚本而不是使用原来的rm命令。（推荐使用方法二）
方法一：（全局用户使用，需要root权限）
```
mv /usr/bin/rm /usr/bin/rm.bak
ln -s <absolute_path>/rm /usr/bin/rm
```
如果要使用原来的脚本：
```
mv /usr/bin/rm.bak /usr/bin/rm
```
方法二：（全局用户使用，需要root权限）
```
echo "alias rm='<absolute_path>/rm'" >> /etc/bashrc
source /etc/bashrc
```
如果要使用原来的脚本：
```
\rm
```
方法三：（个人用户使用，不需要root权限）
```
echo "alias rm='<absolute_path>/rm'" >> ~/.bashrc
source ~/.bashrc
```
如果要使用原来的脚本：
```
\rm
```
####restore：
**1、实现功能：**
a、可以查询回收站的文件；
b、可以还原删除的小于2G（默认大小）文件；（前提是你使用上面的脚本来删除文件）
c、有帮助说明的交互提示。

**2、脚本用法：**
查看回收站的文件：
```
restore -l
或：
restore --list
```
还原已删除的文件：
```
restore -r <file_name1> [<file_name2>]...
或：
restore --restore <file_name1> [<file_name2>]...
```
查看说明文档：
```
restore -h
或：
restore --help
```
####crontab.sh:
**1、实现功能：**
检测回收站占用空间的大小，超过2G（默认）则清理回收站中7天前的文件。（除了.history文件）
**2、脚本用法：**
加进root用户的crontab里面：
```
echo "0 0 * * * /bin/bash <path>/crontab.sh" >> /var/spool/cron/root
```
<font color=red>注：如果加入普通用户的crontab的话，就只能清理回收站中的个人目录。</font>
***
###与我联系：
E-mail：`rebelsre@gmail.com`