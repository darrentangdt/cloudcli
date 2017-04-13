#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_ETHERCHANNEL_DET.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:EtherChannel网卡参数值检查
#
#************************************************#
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		cat ${log_dir}/SYSAUD_VIOS_AIX_ETHERCHANNEL_RES.out
	else
		exit 0
fi
