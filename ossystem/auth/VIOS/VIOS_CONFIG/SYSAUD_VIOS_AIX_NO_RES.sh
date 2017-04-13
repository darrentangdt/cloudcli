#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_NO_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年 1月15日
# 功  能：检查系统网络参数值
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
logfile=SYSAUD_VIOS_AIX_NO_RES.out
>${logfile}
rfc=`no -a|awk '/rfc1323/{print $3}'`
tcp_s=`no -a|awk '/tcp_sendspace/{print $3}'`
tcp_r=`no -a|awk '/tcp_recvspace/{print $3}'`

if [ ${rfc} -eq 1 ]
	then
		:
	else
		echo "${rfc}参数设置不合规,标准值是1" >> ${logfile}
fi
if [ ${tcp_s} -eq 262144 ]
	then
		:
	else
		echo  "${tcp_s}参数设置不合规,标准值是262144" >> ${logfile}
fi
if [ ${tcp_r} -eq 262144 ]
	then
		:
	else
		echo  "${tcp_s}参数设置不合规,标准值是262144" >> ${logfile}
fi
if [ -s ${logfile} ]
		then
		echo "Non-Compliant"
		echo "异常,存在不合规的网络参数 " >> ${logfile}
	else
		echo "Compliant"
		echo "正常" >${logfile}
fi
