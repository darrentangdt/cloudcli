#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_ROOTVGDISKCHANNEL_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:rootvg的disk的通道设置
# 复核人:
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOC_AIX_ROOTVGDISKCHANNEL_RES.out
>${logfile}
if [ `lspath -AEl hdisk0 -p vscsi0|grep priority|awk '{print $2}'` -eq 1 ]
	then
		:
	else
		echo "hdisk0,vscsi0该通道设置不合规" >> ${logfile}
fi
if [ `lspath -AEl hdisk0 -p vscsi1|grep priority|awk '{print $2}'` -eq 2 ]
	then
		:
	else
		echo "hdisk0,vscsi1该通道设置不合规" >> ${logfile}
fi
if [ `lspath -AEl hdisk1 -p vscsi0|grep priority|awk '{print $2}'` -eq 2 ]
	then
		:
	else
		echo "hdisk1,vscsi0该通道设置不合规" >> ${logfile}
fi
if [ `lspath -AEl hdisk1 -p vscsi1|grep priority|awk '{print $2}'` -eq 1 ]
	then
		:
	else
		echo "hdisk1,vscsi1该通道设置不合规" >> ${logfile}
fi
if [ -s ${logfile} ]
	then
		echo "Non-Compliant"
		echo "异常,rootvg的disk的通道设置不合规,请检查" >>${logfile}
	else
		echo "Compliant"
		echo "正常" > ${logfile}
fi