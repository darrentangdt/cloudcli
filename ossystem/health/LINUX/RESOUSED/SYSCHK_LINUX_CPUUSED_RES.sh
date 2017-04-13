#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_CPUUSED_RES.sh            #
# 作  者：CCSD_liyu                          #
# 日  期：2012年 3月 16日                        #
# 功  能：检查cpu利用率                          #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/health_check/LINUX"
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

v_p1=`grep "V_LIN_HEA_CPUUSED" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
sar >/dev/null 2>&1
if [ $? -eq 0 ]; then
v_cpuper=`sar 2 2 |sed '/^$/d' |tail -n 1 |awk '{print $NF}'`
else
v_cpuper=`vmstat 2 2 |tail -n 1 |awk '{print $15}' |sed '/^$/d'`
fi

v_realcpu=`echo 100 - $v_cpuper |bc`
v_realcpu=`echo $v_realcpu |awk '{printf "%.f",$0}'`

if [ $v_realcpu -gt $v_p1 ]; then
    sleep 2
    sar >/dev/null 2>&1
    if [ $? -eq 0 ]; then
    v_cpuper=`sar 2 2 |sed '/^$/d' |tail -n 1 |awk '{print $NF}'`
    else
    v_cpuper=`vmstat 2 2 |tail -n 1 |awk '{print $15}' |sed '/^$/d'`
    fi
    v_realcpu=`echo 100 - $v_cpuper |bc`
    v_realcpu=`echo $v_realcpu |awk '{printf "%.f",$0}'`
       if [ $v_realcpu -gt $v_p1 ]; then
          sleep 2
          sar >/dev/null 2>&1
          if [ $? -eq 0 ]; then
          v_cpuper=`sar 2 2 |sed '/^$/d' |tail -n 1 |awk '{print $NF}'`
          else
          v_cpuper=`vmstat 2 2 |tail -n 1 |awk '{print $15}' |sed '/^$/d'`
          fi
          v_realcpu=`echo 100 - $v_cpuper |bc`
          v_realcpu=`echo $v_realcpu |awk '{printf "%.f",$0}'`          
            if [ $v_realcpu -gt $v_p1 ]; then
            echo "Non-Compliant"
            echo "当前系统cpu利用率为[$v_realcpu],大于[$v_p1]%" > SYSCHK_LINUX_CPUUSED_RES.out
            else
            echo "Compliant"
            echo "正常" > SYSCHK_LINUX_CPUUSED_RES.out
            fi
        else
          echo "Compliant"
          echo "正常" > SYSCHK_LINUX_CPUUSED_RES.out
        fi
else
echo "Compliant"
echo "正常" > SYSCHK_LINUX_CPUUSED_RES.out
fi


exit 0;