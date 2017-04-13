#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_DISKPARAM_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:磁盘参数值检查
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
logfile=SYSAUD_VIOS_AIX_DISKPARAM_RES.out
>${logfile}
for hdp in `lsdev|awk '/^hdiskpower/{print $1}'`
	do
	if [ `lsattr -El ${hdp}|awk '/^reserve_policy/{print $2}'` = no_reserve ]
		then
			:
		else
		let abc=${abc}+1
		echo "${hdp}参数错误,标准值是no_reserve" >> ${logfile}
	fi
	done

	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,有磁盘参数设置异常,请检查" >>${logfile}
	fi