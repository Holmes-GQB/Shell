#!/bin/bash
# Program:
#   This progarm is using to check hash value.
# history:
#   2018/01/18 rebelsre First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

if [ -z $1 ] ; then
    echo "请使用 sh hash_check.sh 文件名！"
    exit 1
fi

if [ `whereis python | grep "python2" | wc -l` -eq 0 ] ; then
    echo "你的系统没有安装Python2！"
    exit 1
fi

read -p "请输入你要校验的哈希类型(1: MD5 ; 2: SHA-1 ; 3: SHA-256 ; 4: SHA-512)：" Hash

case ${Hash} in
    1)
        python -c "import hashlib,sys;print hashlib.md5(open(sys.argv[1],'rb').read()).hexdigest()" $1
    ;;
    2)
        python -c "import hashlib,sys;print hashlib.sha1(open(sys.argv[1],'rb').read()).hexdigest()" $1
    ;;
    3)
        python -c "import hashlib,sys;print hashlib.sha256(open(sys.argv[1],'rb').read()).hexdigest()" $1
    ;;
    4)
        python -c "import hashlib,sys;print hashlib.sha512(open(sys.argv[1],'rb').read()).hexdigest()" $1
    ;;
    *)
        echo "对不起，你的输入有误！"
        exit 1
    ;;
esac
