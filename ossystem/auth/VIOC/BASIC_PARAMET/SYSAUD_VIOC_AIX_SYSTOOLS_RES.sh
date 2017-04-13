#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_SYSTOOLS_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:nmon是否部署perfpmr、lsof是否安装
# 
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

logfile=SYSAUD_VIOC_AIX_SYSTOOLS_RES.out
>$logfile


crontab -l|grep nmon >/dev/null 2>&1
if [ "$?" -eq 0 ] ;then
  :
else
 echo "nmon不在crontab列表里,不合规" >> $logfile
fi

if [ -s /home/backupfile/sys/tools/perfpmr.sh ];then
   :
else
   echo "perfpmr工具没有安装,不合规" >> $logfile
fi

if [ -s /usr/sbin/lsof ];then
   :
else
   echo "lsof工具没有安装,不合规" >> $logfile
fi

if [ -s "$logfile" ];then
   echo "Non-Compliant"
   echo "异常,请根据报错提示修改错误项" >> $logfile
else
   echo "Compliant"
   echo "正常" > $logfile
fi

exit 0