#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_DUMPSIZE_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：dump空间检查
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
logfile=SYSAUD_VIOS_AIX_DUMPSIZE_RES.out
dump_size=$(echo $(lsvg -l rootvg 2>/dev/null|awk '/lg_dump/ {print $3}')*$(lsvg rootvg 2>/dev/null|awk '/PP SIZE/ {print $6}')|bc)
if [ ${dump_size} -ge 8192 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
	 echo "Non-Compliant"
	 echo "异常,当前dump大小是${dump_size}M , 不合规,标准值应大于8192" >${logfile}
fi
