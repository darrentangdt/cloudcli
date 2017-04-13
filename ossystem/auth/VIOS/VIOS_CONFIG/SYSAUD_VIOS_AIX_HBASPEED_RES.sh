#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_HBASPEED_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:HBA速率检查
# 复核人:
#************************************************#
abc=0
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
logfile=SYSAUD_VIOS_AIX_HBASPEED_RES.out
>${logfile}
#HBA速率检查

for fcs in fcs0 fcs2 fcs4 fcs6
	do
	if [ `fcstat ${fcs}|grep "Port Speed (running)"|awk '{print $4}'` -ne 8 ]
			then
			let abc=${abc}+1
			echo "${fcs}速率不是8G" >>${logfile}
		fi
	done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,存在速率不为8G的HBA卡,请检查" >>${logfile}
	fi