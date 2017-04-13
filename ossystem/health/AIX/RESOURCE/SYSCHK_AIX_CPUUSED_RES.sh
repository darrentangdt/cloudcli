#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_CPUUSED_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查cpu利用率                          #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp
  cd ./tmp
fi
/home/ap/opscloud

v_p1=`grep "V_AIX_HEA_CPUUSED" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_cpuid=`vmstat 2 3|egrep "0|1|2|3|4|5|6|7|8|9"|grep -v System|tail -n 1 |awk '{print $16}'`
#E_error_num=`vmstat 2 5|egrep "0|1|2|3|4|5|6|7|8|9"|grep -v System|awk '{ if ($16<'"$v_p2"') printf "%d\n",$16}'|wc -l|awk '{print $0}'`
v_p2=$(( 100 - $v_cpuid ))

if [ $v_p2 -gt $v_p1 ]; then
   sleep 2
   v_cpuid=`vmstat 2 3|egrep "0|1|2|3|4|5|6|7|8|9"|grep -v System|tail -n 1 |awk '{print $16}'`
   v_p2=$(( 100 - $v_cpuid ))
   if [ $v_p2 -gt $v_p1 ]; then
       sleep 2
       v_cpuid=`vmstat 2 3|egrep "0|1|2|3|4|5|6|7|8|9"|grep -v System|tail -n 1 |awk '{print $16}'`
       v_p2=$(( 100 - $v_cpuid ))
       if [ $v_p2 -gt $v_p1 ]; then
          echo "Non-Compliant"
          echo "当前cpu 利用率为[$v_p2],超过阀值[$v_p1]。" > SYSCHK_AIX_CPUUSED_RES.out
       else
          echo "Compliant"
          echo "正常" > SYSCHK_AIX_CPUUSED_RES.out
       fi
   else
      echo "Compliant"
      echo "正常" > SYSCHK_AIX_CPUUSED_RES.out
   fi
else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_CPUUSED_RES.out
fi

exit 0;