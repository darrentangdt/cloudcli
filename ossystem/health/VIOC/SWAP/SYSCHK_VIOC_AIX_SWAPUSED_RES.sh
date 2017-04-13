#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_SWAPUSED_RES.sh         #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2009年 12月30日                         #
# 功  能:检查交换区使用率                        #
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

v_pgsp=`lsps -s|grep MB|sed -e 's/\%//g'|awk '{print $2}'`
v_p1=`grep "V_AIX_HEA_SWAPUSE" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

if [ $v_pgsp -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "异常,当前交换区使用率为[$v_pgsp]%,超过阀值[$v_p1]% " > SYSCHK_VIOC_AIX_SWAPUSED_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_VIOC_AIX_SWAPUSED_RES.out

fi



exit 0;