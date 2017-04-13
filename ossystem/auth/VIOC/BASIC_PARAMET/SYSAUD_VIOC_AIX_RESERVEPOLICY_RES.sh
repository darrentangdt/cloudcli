#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_RESERVEPOLICY_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:磁盘并发检查
#
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

logfile=SYSAUD_VIOC_AIX_RESERVEPOLICY_RES.out
>${logfile}
for hdk in `lspv|grep -v power|grep -vEw "hdisk0|hdisk1"|awk '{print $1}'`
	do
	if [ `lsattr -El ${hdk}|awk '/reserve_policy/ {print $2}'` = no_reserve ]
	then
		:
	else
		let abc=${abc}+1
		echo "${hdk}的reserve_policy参数设置为`lsattr -El ${hdk}|awk '/reserve_policy/ {print $2}'`,不合规" >> ${logfile}
		fi
done

if [ ${abc} -eq 0 ]
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
		echo "Non-Compliant"
		echo "异常,磁盘并发检查不合规,请检查" >> ${logfile}
fi

exit 0