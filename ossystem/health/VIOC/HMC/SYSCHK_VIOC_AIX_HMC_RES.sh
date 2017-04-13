#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_HMC_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:与HMC的RMC通讯状态检查
# 复核人:
#************************************************#
abc=0
#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSCHK_VIOC_AIX_HMC_RES.out
>${logfile}
#与HMC的RMC通讯状态检查

lsrsrc IBM.MCP|awk -F "=" '/IPAddresses/{print $2}'|awk -F \" '{print $2}'|while read hmc_ip
	do
		if ping -c 4 ${hmc_ip} >/dev/null 2>&1
			then
				:
		else
				let abc=${abc}+1
		fi
	done

if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,该主机无法ping通管理HMC,请检查" >${logfile}
fi