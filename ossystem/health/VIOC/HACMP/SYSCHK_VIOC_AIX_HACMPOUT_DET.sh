#!/bin/sh
#************************************************#
# 文件名：SYSCHK_VIOC_AIX_HACMPOUT_DET.sh        #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2010年 1月4 日                         #
# 功  能：检查hacmp日志是否报错                  #
# 复核人：                                       #
#************************************************#

export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs 
#判断该主机是不是VIOC
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
	else
		cat ${log_dir}/SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi
