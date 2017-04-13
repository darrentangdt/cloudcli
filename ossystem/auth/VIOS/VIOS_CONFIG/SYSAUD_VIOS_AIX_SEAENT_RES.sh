#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_SEAENT_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:SEA网卡参数值
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
logfile=SYSAUD_VIOS_AIX_SEAENT_RES.out
>${logfile}
for seaent in ent15 ent16 ent17
	do
	if [ `lsattr -El ${seaent}|awk '/largesend/{print $2}'` -eq 1 ]&&[ `lsattr -El ${seaent}|awk '/large_receive/{print $2}'` = yes ]
		then
			:
		else
			let abc=${abc}+1
			echo "${seaent}参数设置不合规,largesend不是1或large_receive不是yes" >> ${logfile}
		fi
		done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,SEA网卡参数值设置异常,请检查" >>${logfile}
	fi