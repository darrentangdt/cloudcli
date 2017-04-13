#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_UMASK_RES.sh               
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查用户掩码                           
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_UMASK_RES.out"
> $v_logfile

v_umask=$(cat /etc/profile|grep -v  ^[[:space:]]*#|grep -i UMASK|awk '{print $2}')
[ -z "$v_umask" ] && v_umask="0"
if [ $v_umask -eq 0022 ] || [ $v_umask -eq 022 ] ; then
 echo "合规，配置文件/etc/profile中umask已设置为022">$v_logfile
else
 echo "不合规,配置文件/etc/profile中umask未设置为022" >Conviction.out
 cat /etc/profile|grep -v  ^[[:space:]]*#|grep -i UMASK>>Conviction.out
fi

v_umask2=$(umask)
if [ $v_umask2 -eq 0022 ] || [ $v_umask2 -eq 022 ] ; then
 echo "合规，当前umask值为022">>$v_logfile
else
 echo "不合规,当前umask为 $v_umask2,未设置为022" >>Conviction.out
fi

if [ -s  Conviction.out ];then   
 echo "Non-Compliant"
 cat Conviction.out >> $v_logfile
else
 echo "Compliant"
 echo "合规" >> $v_logfile
fi

[ -f  Conviction.out ] && rm -f  Conviction.out

