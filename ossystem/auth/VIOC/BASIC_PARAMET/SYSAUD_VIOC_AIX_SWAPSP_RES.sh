#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_SWAPSP_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能：检查交换空间
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
logfile=SYSAUD_VIOC_AIX_SWAPSP_RES.out
>$logfile
swap_size=`lsps -a|awk '/hdisk/{print $4}'|sed -n 's/MB//p'`
sys_mem=`prtconf -m|awk '{print $3}'`

	if [ ${sys_mem} -lt 16384 ]
			then
				if [ "${swap_size}" -eq "${sys_mem}" ]
					then
						:
					else
					echo "当前系统swap大小设置不合规,请检查" >> ${logfile}
				fi
				elif [ "${sys_mem}" -ge 16384 and "${sys_mem}" -lt 131072 ]
					then
				if [ "${swap_size}" -eq 16384 ]
					then
						:
					else
					echo "当前系统swap大小设置不合规,请检查" >> ${logfile}
				fi
				elif [ "${sys_mem}" -ge 131072 ]
					then
				if [ "${swap_size}" -eq 32768 ]
					then
						:
					else
					echo "当前系统swap大小设置不合规,请检查" >> ${logfile}
				fi
			fi

if [ -s "${logfile}" ];then
   echo "Non-Compliant"
   echo "异常,swap设置不合规,请检查" >> $logfile
else
   echo "Compliant"
   echo "正常" > $logfile
fi

exit 0