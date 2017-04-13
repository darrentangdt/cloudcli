#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_UMASK_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年 1月15日
# 功  能：检查uasmk设置
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
logfile=SYSAUD_VIOS_AIX_UMASK_RES.out
umask=$(awk '/^umask/{print $2}' /etc/profile 2>/dev/null)
if [ ${umask} -eq 022 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
		echo "Non-Compliant"
		echo "异常, 该系统当前umask值是${umask}, 不合规,请改成022 " >${logfile}
	fi
