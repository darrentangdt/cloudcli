#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_NPIVCFG_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:npiv配置检查
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
logfile=SYSAUD_VIOS_AIX_NPIVCFG_RES.out
>${logfile}
for vfa in vfchost0 vfchost2 vfchost4 vfchost6
	do
if [ `/usr/ios/cli/ioscli lsmap -vadapter ${vfa} -npiv|awk '/FC name/{print $2}'|awk -F \: '{print $2}'` = fcs2 ]
	then
		:
	else
	echo "${vfa}配置不合规,请检查" >> ${logfile}
	fi
done

for vfb in vfchost1 vfchost3 vfchost5 vfchost7
	do
if [ `/usr/ios/cli/ioscli lsmap -vadapter ${vfb} -npiv|awk '/FC name/{print $2}'|awk -F \: '{print $2}'` = fcs6 ]
	then
		:
	else
	echo "${vfb}配置不合规,请检查" >> ${logfile}
	fi
done

 	if [ -s ${logfile} ]
		then
			echo "Non-Compliant"
			echo "异常,有npiv参数设置异常,请检查" >>${logfile}
		else
			echo "Compliant"
			echo "正常" >${logfile}
	fi