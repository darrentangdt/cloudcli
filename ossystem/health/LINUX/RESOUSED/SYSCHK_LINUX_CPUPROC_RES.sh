#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_CPUPROC_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查占cpu最多的进程所用率用利          #
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

v_p1=`grep "V_LIN_HEA_CPUPROC" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`

sar >/dev/null 2>&1
if [ $? -eq 0 ]; then
v_cpuper=`sar 2 2 |sed '/^$/d' |tail -n 1 |awk '{print $NF}'`
else
v_cpuper=`vmstat 2 2 |tail -n 1 |awk '{print $15}' |sed '/^$/d'`
fi

v_realcpu=`echo 100 - $v_cpuper |bc`
v_realcpu=`echo $v_realcpu |awk '{printf "%.f",$0}'`

if [ $v_realcpu -gt 20 ]; then
ps auxwww |sed '1d' |awk '( $3>'"$v_p1"' ) {print $0}' > SYSCHK_LINUX_CPUPROC_RES1.out
if [ -s SYSCHK_LINUX_CPUPROC_RES1.out ]; then
    echo "Non-Compliant"
    echo "以下占用cpu使用率超过[$v_p1]%的进程" > SYSCHK_LINUX_CPUPROC_RES.out
    ps auxwww |head -n 1 >>SYSCHK_LINUX_CPUPROC_RES.out
    cat SYSCHK_LINUX_CPUPROC_RES1.out >> SYSCHK_LINUX_CPUPROC_RES.out
    else
		echo "Compliant"
		echo "正常" > SYSCHK_LINUX_CPUPROC_RES.out
fi
else
		echo "Compliant"
		echo "正常" > SYSCHK_LINUX_CPUPROC_RES.out
fi
rm -f SYSCHK_LINUX_CPUPROC_RES1.out >/dev/null 2>&1

exit 0;