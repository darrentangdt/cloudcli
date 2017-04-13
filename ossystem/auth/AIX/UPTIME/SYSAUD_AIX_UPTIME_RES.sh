#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_UPTIME_RES.sh              #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统运行天数是否超过规定           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep "V_AIX_AUD_UPTIMET" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
v_uptime=`uptime |grep "days" |awk '{print $3}'`
    if [ "$v_uptime" != "" ]; then
    if [ $v_uptime -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "主机当前运行时间为[$v_uptime]天,已超过[$v_p1]天,属不合规" > SYSAUD_AIX_UPTIME_RES.out
   else
    echo "Compliant"
    echo "合规" > SYSAUD_AIX_UPTIME_RES.out
    fi
   else
    echo "Compliant"
    echo "合规" > SYSAUD_AIX_UPTIME_RES.out
    fi




