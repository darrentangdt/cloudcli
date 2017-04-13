#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_PROCNUM_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查aix操作系统进程总数                #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_psnum=`ps -ef |wc -l`
v_p1=`grep "V_AIX_AUD_PROMAXNUM" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`

if [ $v_psnum -gt "$v_p1" ]
then
echo "Non-Compliant"
echo "aix系统当前进程数为[$v_psnum],已超过阀值[$v_p1]" > SYSAUD_AIX_PROCNUM_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_PROCNUM_RES.out
fi


