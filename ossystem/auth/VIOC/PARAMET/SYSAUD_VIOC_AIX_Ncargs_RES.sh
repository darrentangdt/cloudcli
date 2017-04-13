#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_Ncargs_RES.sh           #
# 作  者：iomp_zcw		                           #
# 日  期:2014年 3月10日                          #
# 功  能：检查最大命令行长度设置                 #
# 复核人：                                       #
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
logfile=SYSAUD_VIOC_AIX_Ncargs_RES.out

ncargs=$(lsattr -El sys0 2>/dev/null|awk '/ncargs/{print $2}')
if [ ${ncargs} -eq 256 ]
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
	 echo "Non-Compliant"
	 echo "异常,当前最大命令行长度是 ${ncargs},请检查 " > ${logfile}
fi