#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_OVERTIME_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统登录超时设置                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_tmout=`cat /etc/profile |grep -v "^#" |grep "TMOUT" |awk -F= '{print $2}' |sed 's/[^0-9.-]//g'`
v_p1=`grep "V_AIX_AUD_TMOUT" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
v_tmnum=`echo "$v_tmout" |grep "$v_p1" |wc -l`
if [ -z "$v_tmout" ]; then
echo "Non-Compliant"
echo "/etc/profile配置文件中的TMOUT参数未设置，属不合规" > SYSAUD_AIX_OVERTIME_RES.out
elif [ $v_tmnum -gt 0 ]; then
echo "Compliant"
echo "合规" > SYSAUD_AIX_OVERTIME_RES.out
else
echo "Non-Compliant"
echo "/etc/profile配置文件中的TMOUT参数未设置为[$v_p1],属不合规" > SYSAUD_AIX_OVERTIME_RES.out
fi
