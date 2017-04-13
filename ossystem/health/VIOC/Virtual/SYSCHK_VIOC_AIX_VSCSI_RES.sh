#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_VSCSI_RES.sh			 #
# 作  者:iomp_zcw		                         #
# 日  期:2014年 1月15日                          #
# 功  能:vscsi虚拟设备状态	          			 #
# 复核人:                                        #
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

#vscsi虚拟设备状态
log_file=SYSCHK_VIOC_AIX_VSCSI_RES.out

if [ `lsdev -C|awk '/vscsi/{print $2}'|grep -v Available|wc -l` -eq 0 ]
	then
		echo "Compliant"
		echo "正常" >${log_file}
	else
		echo "Non-Compliant"
		echo "异常,存在状态为非Available的设备,请检查" >${log_file}
	fi
