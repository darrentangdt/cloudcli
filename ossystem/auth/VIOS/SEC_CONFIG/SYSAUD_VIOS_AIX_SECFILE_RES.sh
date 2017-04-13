#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_SECFILE_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年 1月15日
# 功  能：检查不安全文件
# 复核人：
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
logfile=SYSAUD_VIOS_AIX_SECFILE_RES.out
>${logfile}
chk_res=$(for file in /etc/hosts.equiv /.netrc /.rhosts
do
	if ls -la ${file} >/dev/null 2>&1
		then
			echo ok
		else
		echo "${file}文件存在,不合规" >> ${logfile}
	fi
done|grep ok|wc -l)

if [ ${chk_res} -eq 3 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
	echo "Non-Compliant"
	echo "异常,该主机存在不安全的文件,请检查" >>${logfile}
fi
