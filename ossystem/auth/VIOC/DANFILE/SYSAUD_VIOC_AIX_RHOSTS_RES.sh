#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_RHOSTS_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:检查不安全文件
# 
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
logfile=SYSAUD_VIOC_AIX_RHOSTS_RES.out

if [ -f /.rhosts ]
	then
		echo "Non-Compliant"
		echo "异常,系统存在/.rhosts文件,属不合规" > ${logfile}
	else
		echo "Compliant"
		echo "正常" > ${logfile}
fi
