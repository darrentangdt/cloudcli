#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_HWERR_DET.sh            #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2009年 12月30日                         #
# 功  能:检查有无新的硬件错误日志                #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0		
	else
		cat ${log_dir}/SYSCHK_VIOC_AIX_HWERR_RES.out
fi