#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_NOOWNFILE_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年 1月15日
# 功  能：检查无主文件设置
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
logfile=SYSAUD_VIOS_AIX_NOOWNFILE_RES.out
ls -lrt /| sed  '1d' | awk '{print $NF}' | grep -v proc |grep -v home|grep -v sys| while read list
do
 	find /${list} \( -nouser -o -nogroup \) -exec ls -lrt {} \; >> res.out
done
if	[ `wc -l /home/ap/opscloud/logs/res.out|awk '{print $1}'` -eq 0 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
	else
		echo "Non-Compliant"
		echo "异常,该主机存在无主文件,请检查res.out " >${logfile}
	fi