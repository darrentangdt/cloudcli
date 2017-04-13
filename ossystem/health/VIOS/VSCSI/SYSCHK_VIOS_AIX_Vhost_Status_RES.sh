#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_Vhost_Status_RES.sh	   #
# 作  者:iomp_zcw		                             #
# 日  期:2014年 1月15日                          #
# 功  能:vhost设备状态检查  	           				 #
# 复核人:                                        #
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
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

#vhost设备状态检查
if [ `lsdev |awk '/vhost/ {print $2}'|grep -v Available|wc -l` -eq 0 ]
	then
		echo "Compliant"
		echo "正常" >SYSCHK_VIOS_AIX_Vhost_Status_RES.out
	else
		echo "Non-Compliant"
		echo "异常, 存在非Available状态的vhost设备,请检查 " >SYSCHK_VIOS_AIX_Vhost_Status_RES.out
fi
