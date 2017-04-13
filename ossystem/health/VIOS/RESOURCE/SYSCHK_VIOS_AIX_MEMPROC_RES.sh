#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_MEMPROC_RES.sh          #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查内存最多的进程所用内存大小          #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOS
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		:
	else
exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

v_max_mem=`ps auxwww|sort -r +3| grep -v COMMAND | head -n 1 | awk '{print $5}'`
v_p1=`grep "V_AIX_HEA_MEMMAXPRO" /home/ap/opscloud/health_check/VIOS/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_max_mem -gt "$v_p1" ]; then
    echo "Non-Compliant"
	echo "异常,检查结果:ERROR:使用内存最多的进程所用内存为[$v_max_mem]k,已超过阈值[$v_p1]K" > SYSCHK_VIOS_AIX_MEMPROC_RES.out
    ps auxwww |head -n 1 >> SYSCHK_VIOS_AIX_MEMPROC_RES.out
    ps auxwww|sort -r +3| grep -v COMMAND | head -n 1 >> SYSCHK_VIOS_AIX_MEMPROC_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_VIOS_AIX_MEMPROC_RES.out
fi

exit 0;