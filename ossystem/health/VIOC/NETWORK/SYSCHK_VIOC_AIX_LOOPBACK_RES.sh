#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_LOOPBACK_RES.sh         #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2009年 12月30日                         #
# 功  能:检查loopback是否解析                    #
# 复核人:                                        #
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
logfile=SYSCHK_VIOC_AIX_LOOPBACK_RES.out
v_a=0
v_a=`cat /etc/hosts |grep 127.0.0.1 |grep -v "^#" |grep loopback |grep localhost |wc -l`
if [ $v_a -eq 1 ];
then
echo "Compliant"
echo "正常" > ${logfile}

else
echo "Non-Compliant"
echo "异常,主机loopback/localhost不可解析" > ${logfile}
fi

exit 0;