#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_FILESYS_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查文件系统大小
#
#************************************************#
export LANG=ZH_CN.UTF-8
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
	:
	else
	exit 0
fi
#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOS_AIX_FILESYS_RES.out
>${logfile}
if [ `df -g / 2>/dev/null|awk 'NR >1{print $2}'` -eq "4.00" ]
	then
		:
	else
	echo "根分区大小不是4G,不合规" >> ${logfile}
fi
if [ `df -g /home 2>/dev/null|awk 'NR >1{print $2}'` -eq "20.00" ]
	then
		:
	else
	echo "home分区大小不是20G,不合规" >> ${logfile}
fi
if [ `df -g /opt 2>/dev/null|awk 'NR >1{print $2}'` -eq "4.00" ]
	then
		:
	else
	echo "opt分区大小不是4G,不合规" >> ${logfile}
fi
if [ `df -g /tmp 2>/dev/null|awk 'NR >1{print $2}'` -eq "10.00" ]
	then
		:
	else
	echo "tmp分区大小不是10G,不合规" >> ${logfile}
fi
if [ `df -g /usr 2>/dev/null|awk 'NR >1{print $2}'` -eq "8.00" ]
	then
		:
	else
	echo "usr分区大小不是8G,不合规" >> ${logfile}
fi
if [ `df -g /var 2>/dev/null|awk 'NR >1{print $2}'` -eq "8.00" ]
	then
		:
	else
	echo "var分区大小不是8G,不合规" >> ${logfile}
fi
if [ -s ${logfile} ]
	then
		echo "Non-Compliant"
		echo "异常,有文件系统大小不合规,请检查" >> ${logfile}
	else
		echo "Compliant"
		echo "正常" > ${logfile}
fi