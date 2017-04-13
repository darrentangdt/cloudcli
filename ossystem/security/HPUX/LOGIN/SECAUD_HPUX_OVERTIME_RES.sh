#!/bin/sh
#*************************************************#
# 文件名：SECAUD_HPUX_OVERTIME_RES.sh              
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查登录超时策略                        
#*************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_OVERTIME_RES.out"

> $v_logfile


v_overtime=`cat /etc/profile|grep ^[[:space:]]*TMOUT|awk -F"=" '{print $NF}'`
v_overtime2=`cat /etc/profile|grep ^[[:space:]]*"export"|grep TMOUT|awk -F"=" '{print $NF}'`
if [ EOF$v_overtime = EOF ] && [ EOF$v_overtime2 = EOF ];then
echo "当前配置文件/etc/profile未配置超时策略，不合规">>SECAUD_HPUX_OVERTIME_RES1.out
elif [ EOF$v_overtime = EOF120 ]  || [ EOF$v_overtime2 = EOF120 ]; then
echo "当前配置文件/etc/profile超时策略为120，合规">>SECAUD_HPUX_OVERTIME_RES.out
else
echo "当前配置文件/etc/profile超时策略为 $v_overtime $v_overtime2，不合规">>SECAUD_HPUX_OVERTIME_RES1.out
fi


if [ -s  SECAUD_HPUX_OVERTIME_RES1.out ];then
    echo "Non-Compliant"
    cat SECAUD_HPUX_OVERTIME_RES1.out >> $v_logfile
else
    echo "Compliant"
fi
rm -f SECAUD_HPUX_OVERTIME_RES1.out
