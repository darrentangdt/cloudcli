#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_MEMPROC_RES.sh            #
# 作  者：CCSD_liyu                   #
# 日  期：2012年 3月8日                        #
# 功  能：检查内存利用率                         #
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

v_OUT="SYSCHK_LINUX_MEMPROC_RES.out"
> $v_OUT

v_p1=`grep "V_LIN_HEA_MEMUSED" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
v_used=`free |sed -n 3p | awk '{print $3}'`
v_total=`free |sed -n 2p | awk '{print $2}'`
#echo "used:$v_used    totoal:$v_total"
v_perf=$(($v_used *100 / $v_total))
#echo "value:$v_perf"
if [ $v_perf -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "当前系统内存实际使用率为[$v_perf]%,已超过[$v_p1]%"  >> $v_OUT
#    echo "linux实际内存使用率为memused = (used - buffers - cached)" >> $v_OUT
    echo "使用 free -m 命令检查内存,显示结果如下:" >> $v_OUT 
    free -m >> $v_OUT 
else
    echo "Compliant"
    echo "正常" > $v_OUT
    echo "使用 free -m 命令检查内存,显示结果如下:" >> $v_OUT
    free -m >> $v_OUT 
fi

exit 0;