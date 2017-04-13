#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_MEMUSED_RES.sh
# 作  者:CCSD_liyu
# 日  期:2014年2月10日
# 功  能:检查内存利用率
# 复核人:
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

logfile=SYSCHK_VIOC_AIX_MEMUSED_RES.out
mem_used=`vmstat -v|awk '/percentage of memory used/{print $1}'`
if [ X${mem_used} = X ]
	then
		echo "Non-Compliant"
		echo "异常,vmstat没有检查出当前系统的内存使用率,请检查" > ${logfile}
exit 0
fi
if [ ${mem_used} -gt 70 ]
	then
		echo "Non-Compliant"
		echo "异常,当前内存利用率为${mem_used},大于阈值70" > ${logfile}
	else
   echo "Compliant"
   echo "正常" > ${logfile}
fi