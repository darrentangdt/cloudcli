#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_ETHERCHANNEL_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:EtherChannel网卡参数值检查
# 复核人:
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
logfile=SYSAUD_VIOS_AIX_ETHERCHANNEL_RES.out
>${logfile}
for et_c in ent12 ent13 ent14
	do
	if [ `lsattr -El ${et_c}|awk '/hash_mode/{print $2}'` = default ]
		then
			:
		else
			echo "${et_c}参数hash_mode设置不合规" >> ${logfile}
		fi
		if [ `lsattr -El ${et_c}|awk '/^mode/{print $2}'` = "8023ad" ]
					then
			:
		else
			echo "${et_c}参数mode设置不合规" >> ${logfile}
		fi
		done
	if [ -s ${logfile} ]
		then
			echo "Non-Compliant"
			echo "异常,EtherChannel网卡参数值设置异常,请检查" >>${logfile}
		else
			echo "Compliant"
			echo "正常" >${logfile}
	fi