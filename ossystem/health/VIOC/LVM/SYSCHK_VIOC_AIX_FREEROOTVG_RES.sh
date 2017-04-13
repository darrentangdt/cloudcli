#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_FREEROOTVG_RES.sh       #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查rootvg中没被分配的剩余的空间大小    #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

#使用freepp的剩余megabytes数量来进行大小计算

v_p2=`grep "V_AIX_HEA_FREEPPS_SIZE" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

if [ -z "$v_p2" ];then
   v_freevg=`lsvg rootvg |grep "FREE PPs:" |awk -F: '{print $3}' |awk '{print $1}'`
   v_totvg=`lsvg rootvg |grep "TOTAL PPs:" |awk -F: '{print $3}' |awk '{print $1}'`
   v_percent=$(($v_freevg *100 / $v_totvg))
   v_p1=`grep "V_AIX_HEA_FREEPPS=" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
   if [ $v_percent -lt "$v_p1" ]; then
   echo "Non-Compliant"
   echo "异常,当前rootvg free空间大小与总空间大小比值为[$v_percent]%,小于[$v_p1]%阀值" > SYSCHK_VIOC_AIX_FREEROOTVG_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_VIOC_AIX_FREEROOTVG_RES.out
   fi
else 
   v_freePP=`lsvg rootvg | awk '/FREE PPs:/{print $7}' |sed 's/(//g'`
   v_FREE_PPs=`lsvg rootvg | awk '/FREE PPs:/{print $7" "$8}'`
   if [ "$v_freePP" -lt "$v_p2" ]; then
   echo "Non-Compliant"
   echo "异常,当前rootvg free空间大小与总空间为 $v_FREE_PPs ,小于[ $v_p2 megabytes]阀值"  > SYSCHK_VIOC_AIX_FREEROOTVG_RES.out 
   else
   echo "Compliant"
   echo "正常" > SYSCHK_VIOC_AIX_FREEROOTVG_RES.out
   fi
fi

exit 0;