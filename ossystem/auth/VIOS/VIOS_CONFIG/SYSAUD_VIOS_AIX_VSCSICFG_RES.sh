#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_VSCSICFG_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:vscsi配置检查
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
logfile=SYSAUD_VIOS_AIX_VSCSICFG_RES.out
>${logfile}
vhost0_1=`/usr/ios/cli/ioscli lsmap -vadapter vhost0|awk '/Backing device/{print $3}'|sed '2d'`
vhost0_2=`/usr/ios/cli/ioscli lsmap -vadapter vhost0|awk '/Backing device/{print $3}'|sed '1d'`
vhost1_1=`/usr/ios/cli/ioscli lsmap -vadapter vhost1|awk '/Backing device/{print $3}'|sed '2d'`
vhost1_2=`/usr/ios/cli/ioscli lsmap -vadapter vhost1|awk '/Backing device/{print $3}'|sed '1d'`
vhost2_1=`/usr/ios/cli/ioscli lsmap -vadapter vhost2|awk '/Backing device/{print $3}'|sed '2d'`
vhost2_2=`/usr/ios/cli/ioscli lsmap -vadapter vhost2|awk '/Backing device/{print $3}'|sed '1d'`
vhost3_1=`/usr/ios/cli/ioscli lsmap -vadapter vhost3|awk '/Backing device/{print $3}'|sed '2d'`
vhost3_2=`/usr/ios/cli/ioscli lsmap -vadapter vhost3|awk '/Backing device/{print $3}'|sed '1d'`
 if [ ${vhost0_1} = hdiskpower0 ] 2>/dev/null && [ ${vhost0_2} = hdiskpower4 ] 2>/dev/null
 	then
 		:
 	else
 		echo "vhost0参数设置不合规" >>${logfile}
 fi
 if [ ${vhost1_1} = hdiskpower1 ] 2>/dev/null && [ ${vhost0_2} = hdiskpower5 ] 2>/dev/null
 	then
 		:
 	else
 		echo "vhost0参数设置不合规" >>${logfile}
 fi
  if [ ${vhost2_1} = hdiskpower2 ] 2>/dev/null && [ ${vhost1_2} = hdiskpower6 ] 2>/dev/null
 	then
 		:
 	else
 		echo "vhost1参数设置不合规" >>${logfile}
 fi
  if [ ${vhost3_1} = hdiskpower3 ] 2>/dev/null && [ ${vhost3_2} = hdiskpower7 ] 2>/dev/null
 	then
 		:
 	else
 		echo "vhost3参数设置不合规" >>${logfile}
 fi

 	if [ -s ${logfile} ]
		then
			echo "Non-Compliant"
			echo "异常,有vhost参数设置异常,请检查" >>${logfile}
		else
			echo "Compliant"
			echo "正常" >${logfile}
	fi