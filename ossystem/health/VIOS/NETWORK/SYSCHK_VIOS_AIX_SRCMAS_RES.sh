#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_SRCMAS_RES.sh
# 作  者:CCSD_YOUTONGLI
# 日  期:2009年 12月30日
# 功  能:检查srcmas进程
# 复核人:
#************************************************#

#判断该台主机是不是VIOS
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		:
	else
exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opscloud/logs
  cd /home/ap/opscloud/logs
fi

v_a=0
v_a=`ps -ef|grep srcmstr |grep -v grep`
if [ "$v_a" = "" ]
then
echo "Non-Compliant"
echo "异常,srcmstr进程不存在 " > SYSCHK_VIOS_AIX_SRCMAS_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_VIOS_AIX_SRCMAS_RES.out
fi



exit 0;