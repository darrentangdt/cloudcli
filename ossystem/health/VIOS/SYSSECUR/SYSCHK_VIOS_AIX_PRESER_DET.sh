#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_PRESER_DET.sh           #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:异常终止的vi日志大小检查                #
# 复核人:                                        #
#************************************************#
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		cat ${log_dir}/SYSCHK_VIOS_AIX_PRESER_RES.out
	else
		exit 0
fi


