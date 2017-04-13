#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_TRANERR_RES.sh          #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2009年 12月30日                         #
# 功  能:检查网络传输错误                        #
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

v_a=`netstat -v|grep "Transmit Errors" |awk -F: '{size+=$2}END{print size}'`
v_b=`netstat -v|grep "Transmit Errors" |awk -F: '{size+=$3}END{print size}'`
v_p1=`grep "V_AIX_HEA_NETERROR" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

if [[ $v_a -gt "$v_p1" || $v_b -gt "$v_p1" ]]; then
    echo "Non-Compliant"
    echo "异常,网络有传输错误 " > SYSCHK_VIOC_AIX_TRANERR_RES.out
    netstat -v|grep "Transmit Errors" >> SYSCHK_VIOC_AIX_TRANERR_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_VIOC_AIX_TRANERR_RES.out
fi

exit 0;