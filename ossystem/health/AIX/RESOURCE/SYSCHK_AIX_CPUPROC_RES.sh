#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_CPUPROC_RES.sh              #
# 作  者：CCSD_liyu                              #
# 日  期：2013年01月07日                         #
# 功  能：检查cpu利用率最高的进程                #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSCHK_AIX_CPUPROC_RES.out"
> $logfile

v_p1=$(awk -F= '/V_AIX_HEA_CPUMAXPRO/{print $2}' /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt)
[ -z "$v_p1" ] && v_p1="30"
ps aux |sed '1d'| awk '($3>'"$v_p1"') {print $0}' |grep -vE "defunct|wait" >> $logfile
if [ -s "$logfile" ]; then
    echo "Non-Compliant"
    echo "以上进程所占用CPU已超过[$v_p1]%" >> $logfile
else
    echo "Compliant"
    echo "正常" >> $logfile
fi

exit 0;