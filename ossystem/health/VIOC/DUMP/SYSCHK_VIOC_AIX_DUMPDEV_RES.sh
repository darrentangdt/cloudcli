#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_DUMPDEV_RES.sh          #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:dump设备空间检查                        #
# 复核人:                                        #
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
logfile=SYSCHK_VIOC_AIX_DUMPDEV_RES.out
>${logfile}
/usr/lib/ras/dumpcheck -p >VIOC_DUMPDEV_RES.out 2>&1
if [ -s VIOC_DUMPDEV_RES.out ]
then
   echo "Non-Compliant"
   echo "异常,dump设备空间不够用,请检查" > ${logfile}
   echo "/usr/lib/ras/dumpcheck -p 命令输出结果如下"  >> ${logfile}
   /usr/lib/ras/dumpcheck -p  >> ${logfile} 2>&1
   else
   echo "Compliant"
   echo "正常" > ${logfile}

fi

exit 0;