#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_ROOTVGQ_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查rootvgQUORUM状态
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
logfile=SYSAUD_VIOS_AIX_ROOTVGQ_RES.out
quorum=$(lsvg rootvg 2>/dev/null|awk '/QUORUM:/ {print $5}')
if [ ${quorum} -eq 1 ]
	then
	 echo "Compliant"
	 echo "正常" >${logfile}
	else
	 echo "Non-Compliant"
	 echo "异常,当前系统rootvg的QUORUM值是${quorum},不合规,标准值是1 " >${logfile}
fi