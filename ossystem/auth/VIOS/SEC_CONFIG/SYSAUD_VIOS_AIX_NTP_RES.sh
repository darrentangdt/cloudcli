#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_NTP_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查NTP时钟同步设置
#
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
logfile=SYSAUD_VIOS_AIX_NTP_RES.out
>${logfile}
dri="driftfile /home/padmin/config/ntp.drift"
tra="tracefile /home/padmin/config/ntp.trace"
log="logfile /home/padmin/config/ntp.log"
se1="server 11.155.55.40 perfer"
se2="server 11.155.55.42"
se3="server 11.155.55.44"
file="/home/padmin/config/ntp.conf"

if lssrc -ls xntpd >/dev/null 2>&1
	then
		if  grep -v ^# ${file}|grep -w "${dri}"
			then
				:
			else
				echo "driftfile设置不合规" >> ${logfile}
		fi
		if  grep -v ^# ${file}|grep -w "${tra}"
			then
				:
			else
				echo "tracefile设置不合规" >> ${logfile}
		fi
		if  grep -v ^# ${file}|grep -w "${log}"
			then
				:
			else
				echo "logfile设置不合规" >> ${logfile}
		fi
		if  grep -v ^# ${file}|grep -w "${se1}"
			then
				:
			else
				echo "server设置不合规" >> ${logfile}
		fi
		if  grep -v ^# ${file}|grep -w "${se2}"
			then
				:
			else
				echo "server设置不合规" >> ${logfile}
		fi
		if  grep -v ^# ${file}|grep -w "${se3}"
			then
				:
			else
				echo "server设置不合规" >> ${logfile}
		fi
	else
	echo "Non-Compliant"
	echo "异常,ntp服务异常,请检查" >>${logfile}
fi
if [ -s ${logfile} ]
	then
		echo "Non-Compliant"
		echo "异常,ntp配置文件不合规，请检查" >>${logfile}
	else
		echo "Compliant"
		echo "正常" >${logfile}
fi