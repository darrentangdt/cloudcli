#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_PWCK_RES.sh                
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查用户认证信息的完整性               
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi
[ -f  Conviction.out ] && rm -f  Conviction.out

v_logfile="SECAUD_HPUX_PWCK_RES.out"
> $v_logfile

pwck -l >/dev/null 2>&1
if [ $? -eq 0 ]; then
echo "Compliant" 
echo "合规">$v_logfile
else
pwck -l 2>Conviction.out
cat /home/ap/opsware/script/tmp/Conviction.out|grep passwd|grep -v  ^[[:space:]]*#|grep -v false$|awk -F":" '{print substr($1,15)}'|uniq>Conviction1.out
if [ -s Conviction1.out ];then 
echo "不合规,以下用户认证信息不完整性" >$v_logfile
cat /home/ap/opsware/script/tmp/Conviction1.out>>$v_logfile
echo "Non-Compliant"
else 
echo "Compliant" 
echo "合规">$v_logfile
fi
fi
[ -f  Conviction.out ] && rm -f  Conviction.out
[ -f  Conviction1.out ] && rm -f  Conviction1.out
