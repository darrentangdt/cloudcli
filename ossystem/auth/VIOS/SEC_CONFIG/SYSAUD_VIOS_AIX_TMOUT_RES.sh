#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_TMOUT_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年 1月15日
# 功  能：检查超时时间
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
logfile=SYSAUD_VIOS_AIX_TMOUT_RES.out
tmout=$(awk -F "=" '/export TMOUT=/{print $2}' /etc/profile 2>/dev/null)
if [ ${tmout} -eq 120 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
		echo "Non-Compliant"
		echo "异常,当前系统超时时间值是${tmout},不合规,请修改成120 " >${logfile}
	fi
