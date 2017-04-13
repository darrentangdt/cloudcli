#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_SHADOW_RES.sh              
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查是否启动了shadow password          
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_SHADOW_RES.out"
> $v_logfile

[ -f  Conviction.out ] && rm -f  Conviction.out

if [ -f /etc/shadow ];then 
cat /etc/passwd |grep -v  ^[[:space:]]*#|grep sh$ |awk -F: '$2!~/x/ {print $1}'|uniq| while read v_ss
do
 set $v_ss
 grep $v_ss /etc/shadow >/dev/null 2>&1
 v_result=`echo $?`
    if [ "$v_result" -ne 0 ];then  
echo "$v_ss 用户未配置shadow password">>Conviction.out
fi
done
    if [ -s  Conviction.out ];then
   	echo "Non-Compliant"
  	cat Conviction.out >> $v_logfile
    else
        echo "Compliant"
        echo "合规" >> $v_logfile
    fi
else
    echo "Non-Compliant"
    echo "不合规，本机未配置shadow password" >> $v_logfile
fi
[ -f  Conviction.out ] && rm -f  Conviction.out

