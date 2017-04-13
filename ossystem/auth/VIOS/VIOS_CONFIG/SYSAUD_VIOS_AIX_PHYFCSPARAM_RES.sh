#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_PHYFCSPARAM_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:物理光纤卡参数值检查
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
logfile=SYSAUD_VIOS_AIX_PHYFCSPARAM_RES.out
>${logfile}

for fscsi in fscsi0 fscsi2 fscsi4 fscsi6
	do
	if [ `lsattr -El ${fscsi}|awk '/dyntrk/{print $2}'` = yes ]&&[ `lsattr -El ${fscsi}|awk '/fc_err_recov/{print $2}'` = fast_fail ]
		then
			:
		else
			let abc=${abc}+1
			echo "${fscsi}参数设置不合规" >> ${logfile}
		fi
		done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,有物理光纤卡参数设置异常,请检查" >>${logfile}
	fi