#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_VFCSTATUS_DET.sh		 #
# 作  者:iomp_zcw		                         #
# 日  期:2014年 1月15日                          #
# 功  能:vfc设备状态检查						 #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0		
	else
		cat ${log_dir}/SYSCHK_VIOC_AIX_VFCSTATUS_RES.out
fi