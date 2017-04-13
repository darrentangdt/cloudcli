#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_NETSTAT_RES.sh
# 作  者:CCSD_YOUTONGLI
# 日  期:2010年 1月4日
# 功  能:检查路由状态
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

v_strings=`netstat -rn | grep default | awk '{print $2}'|grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
ping -c 5 $v_strings > SYSCHK_VIOS_AIX_NETSTAT_RES.out
if [ $? -eq 0 ]; then
echo "Compliant"
echo "正常" > SYSCHK_VIOS_AIX_NETSTAT_RES.out

else
echo "Non-Compliant"
echo "异常,系统默认路由不通畅" > SYSCHK_VIOS_AIX_NETSTAT_RES.out
fi



exit 0;