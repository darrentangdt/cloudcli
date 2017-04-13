#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_TIMEZONE_RES.sh        
# 作  者：iomp_zcw		                           
# 日  期：2014年2月10日                          
# 功  能：检查系统时区                           
# 复核人：                                       
#************************************************#
export LANG=ZH_CN.UTF-8
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
	 :
	else
	exit 0
fi
#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOS_AIX_TIMEZONE_RES.out
if grep "^TZ=Asia/Shanghai" /etc/environment >/dev/null  2>&1
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
	echo "Non-Compliant"
	echo "异常,当前系统时区是`awk -F "=" '/^TZ/{print $2}'`,标准值是TZ=Asia/Shanghai" >${logfile}
fi
