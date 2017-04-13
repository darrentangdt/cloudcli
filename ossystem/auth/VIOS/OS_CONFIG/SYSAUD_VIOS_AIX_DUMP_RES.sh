#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_DUMP_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查dump项设置
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
logfile=SYSAUD_VIOS_AIX_DUMP_RES.out
>${logfile}
f_c_flag=`sysdumpdev -l 2>/dev/null|awk '/forced copy flag/{print $4}'`
a_a_dump=`sysdumpdev -l 2>/dev/null|awk '/always allow dump/{print $4}'`
d_compression=`sysdumpdev -l 2>/dev/null|awk '/dump compression/{print $3}'`
c_directory=`sysdumpdev -l 2>/dev/null|awk '/copy directory/{print $3}'`

if [ ${f_c_flag} = TRUE ]
	then
		:
	else
		echo "forced copy flag项设置不合规,标准值是TRUE" >>${logfile}
fi
if [ ${a_a_dump} = TRUE ]
	then
		:
	else
		echo "always allow dump项设置不合规,标准值是TRUE" >>${logfile}
fi
if [ ${d_compression} = "/home/coredump" ]
	then
		:
	else
		echo "dump compression项设置不合规,标准值是"/home/coredump" " >>${logfile}
fi
if [ ${c_directory} = ON ]
	then
		:
	else
		echo "copy directory项设置不合规,标准值是ON" >>${logfile}
fi
if [ -s ${logfile} ]
	then
		echo "Non-Compliant"
		echo "异常,存在不合规dump项,请检查" >>${logfile}
	else
		echo "Compliant"
		echo "正常" >${logfile}
fi