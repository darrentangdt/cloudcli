#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_PS1_RES.sh             #
# 作  者:iomp_zcw                                #
# 日  期:2014年 3月10日                          #
# 功  能：检查系统提示符PS1设置                  #
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
logfile=SYSAUD_VIOC_AIX_PS1_RES.out

if grep -w "PS1=\`whoami\`\@\`hostname\`\:\'\$PWD\>\'" /etc/profile >/dev/null 2>&1
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
	echo "Non-Compliant"
	echo "异常,系统提示符错误,请检查" > ${logfile}
fi