#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_NTP_RES.sh         	 #
# 作  者:iomp_zcw                                #
# 日  期:2014年 3月10 日                         #
# 功  能:NTP服务检查                             #
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
logfile=SYSAUD_VIOC_AIX_NTP_RES.out
if [ `ntpq -p|awk 'NR>2 {print $9}'` -lt 120 ]
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
		echo "Non-Compliant"
		echo "异常,本机时间与NTP服务器时间偏差大于120MS或NTP服务异常,请检查" > ${logfile}
fi