#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_ROOTVGDISKPARA_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:rootvg的disk参数设置
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
logfile=SYSAUD_VIOC_AIX_ROOTVGDISKPARA_RES.out
>${logfile}
for hdk in hdisk0 hdisk1
	do
		if [ `lsattr -El ${hdk}|grep -w hcheck_mode|awk '{print $2}'` = nonactive ]&&[ `lsattr -El ${hdk}|grep -w hcheck_interval|awk '{print $2}'` -eq 60 ]
			then
				:
			else
				let abc=${abc}+1
				echo "${hdk}参数设置错误,请检查" >>${logfile}			
fi
done

if [ ${abc} -eq 0 ]
	then
		echo "Compliant"
		echo "正常" > ${logfile}
	else
		echo "Non-Compliant"
		echo "异常,rootvg的disk参数不合规,请检查" >>${logfile}
fi