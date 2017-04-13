#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_FSCSIPARA_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:fscsi卡参数设置
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
logfile=SYSAUD_VIOC_AIX_FSCSIPARA_RES.out
>${logfile}
for vfc in fscsi0 fscsi1 fscsi2 fscsi3
	do
		if [ `lsattr -El ${vfc}|grep -w fc_err_recov|awk '{print $2}'` = fast_fail ]&&[ `lsattr -El ${vfc}|grep -w dyntrk|awk '{print $2}'` = yes ]
			then
				:
			else
				echo "${vfc}参数设置不合规" >> ${logfile}
		fi
done
if [ ${abc} -eq 0 ]
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
		echo "Non-Compliant"
		echo "异常,fscsi卡参数设置不合规,请检查" >>${logfile}
fi