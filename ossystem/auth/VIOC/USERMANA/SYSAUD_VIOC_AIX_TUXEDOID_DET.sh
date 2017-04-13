#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_TUXEDOID_DET.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查tuxedo用户ID                       #
# 复核人：                                       #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
	else
		cat ${log_dir}/SYSAUD_VIOC_AIX_TUXEDOID_RES.out
fi

