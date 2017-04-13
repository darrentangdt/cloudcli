#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_PATH_RES.sh                
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查PATH环境变量                       
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_PATH_RES.out"
> $v_logfile

echo $PATH|grep -E '^\.:|:\.$|^\.\/|:\.\/$|:\.:|:\.\/:' >/dev/null
if [ $? -eq 0 ]; then
echo "PATH包含当前路径，当前路径为$PATH">Conviction.out
fi

echo $PATH|grep -E  "^:"  >/dev/null
if [ $? -eq 0 ]; then
        echo "PATH包含以：开头路径，当前路径为$PATH,">>Conviction.out
fi

echo $PATH|grep '::'  >/dev/null
if [ $? -eq 0 ]; then
        echo "PATH包含::路径，当前路径为$PATH">>Conviction.out
fi

echo $PATH|grep -E ':$'  >/dev/null
if [ $? -eq 0 ]; then
        echo "PATH包含以:结尾的路径,当前路径为$PATH,">>Conviction.out
fi

if [ -s  Conviction.out ];then
 echo "Non-Compliant"
 cat Conviction.out >> $v_logfile
else
 echo "Compliant"
 echo "合规" >> $v_logfile
fi
rm -f Conviction.out
