#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_Vhost_Status_DET.sh  	 #
# 作  者:iomp_zcw		                         #
# 日  期:2014年 1月15日                          #
# 功  能:vhost设备状态检查  	           		  #
# 复核人:                                        #
#************************************************#
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		cat ${log_dir}/SYSCHK_VIOS_AIX_Vhost_Status_RES.out
	else
		exit 0
fi
