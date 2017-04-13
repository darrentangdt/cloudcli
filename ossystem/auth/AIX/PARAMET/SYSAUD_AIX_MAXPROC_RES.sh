#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_MAXPROC_RES.sh              #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2013年 5月8日                          #
# 功  能：检查用户最大进程数                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_maxproc=`lsattr -El sys0 |grep "maxuproc" |awk '{print $2}'`
v_p1=`grep "V_AIX_AUD_MAXPROC" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
v_p2="16384"

if [ $v_maxproc -ge "$v_p1" ] && [ $v_maxproc -le "$v_p2" ]; then
   echo "Compliant"
   echo "合规" > SYSAUD_AIX_MAXPROC_RES.out
   else
   echo "Non-Compliant"
   echo "当前的用户最大进程数设置为[$v_maxproc],未设置为大于等于[$v_p1]并小于等于[$v_p2],属不合规" > SYSAUD_AIX_MAXPROC_RES.out
fi
