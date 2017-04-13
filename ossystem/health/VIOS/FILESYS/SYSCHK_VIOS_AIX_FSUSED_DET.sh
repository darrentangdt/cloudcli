#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_FSUSED_DET.sh
# 作  者:CCSD_YOUTONGLI
# 日  期:2009年 12月30日
# 功  能:检查文件系统使用率
# 复核人:
#************************************************#
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		cat ${log_dir}/SYSCHK_VIOS_AIX_FSUSED_RES.out
	else
		exit 0
fi


