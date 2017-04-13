#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_BOOTLIST_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查系统启动项设置
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
logfile=SYSAUD_VIOS_AIX_BOOTLIST_RES.out

hd0=$(bootlist -m normal -o 2>/dev/null|awk '/hdisk0/{print $2}')
hd1=$(bootlist -m normal -o 2>/dev/null|awk '/hdisk1/{print $2}')
if [ ${hd0} = "blv=hd5" ]&&[ ${hd1} = "blv=hd5" ]
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
	 echo "Non-Compliant"
	 echo "异常,当前启动项设置为`bootlist -m normal -o` ,不合规,标准值blv应该是hd5" >${logfile}
fi