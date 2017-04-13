#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_MEMUSED_RES.sh              #
# 作  者：CCSD_liyu                              #
# 日  期：2012年 8月 7日                         #
# 功  能：检查内存利用率                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi

svmon -G >/dev/null 2>&1
if [ $? -eq 0 ]; then
v_in_use=`svmon -G |sed -n '7p'|awk '{print $3}'`
v_memtot=`svmon -G|sed -n '2p' |awk '{print $2}'`
v_p1=`grep "V_AIX_HEA_MEMUSED" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="70"
v_percent=$(($v_in_use *100 / $v_memtot))

if [ "$v_percent" -gt "$v_p1" ]; then
   echo "Non-Compliant"
   echo "当前内存利用率为[$v_percent]%,大于阀值[$v_p1]%" > SYSCHK_AIX_MEMUSED_RES.out
   svmon -G >> SYSCHK_AIX_MEMUSED_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_MEMUSED_RES.out
   echo "svmon -G命令显示结果为:" >> SYSCHK_AIX_MEMUSED_RES.out
   svmon -G >> SYSCHK_AIX_MEMUSED_RES.out
fi
else
   echo "Non-Compliant"
   echo "系统无svmon命令" > SYSCHK_AIX_MEMUSED_RES.out
fi

exit 0;