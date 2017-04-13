#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_SEA_Priority_RES.sh	   #
# 作  者:iomp_zcw		                             #
# 日  期:2014年 1月15日                          #
# 功  能:SEA优先级状态检查  	           				 #
# 复核人:                                        #
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

#SEA优先级状态检查
if hostname|grep -i vios1
	then
		[ `entstat -d ent15 2>/dev/null|awk '/Priority.*Active/ {print $NF}'` = True ]&&[ `entstat -d ent16 2>/dev/null|awk '/Priority.*Active/ {print $NF}'` = False ]&&[ `entstat -d ent17 2>/dev/null|awk '/Priority.*Active/ {print $NF}'` = False ]
		echo "Compliant"
		echo "正常" >SYSCHK_VIOS_AIX_SEA_Priority_RES.out
	elif hostname|grep -i vios2
	then
		[ `entstat -d ent15 2>/dev/null|awk '/Priority.*Active/ {print $NF}'` = False ]&&[ `entstat -d ent16 2>/dev/null|awk '/Priority.*Active/ {print $NF}'` = True ]&&[ `entstat -d ent17 2>/dev/null|awk '/Priority.*Active/ {print $NF}'` = True ]
		echo "Compliant"
		echo "正常" >SYSCHK_VIOS_AIX_SEA_Priority_RES.out
	else
		echo "Non-Compliant"
		echo "异常, 该主机的SEA优先级状态异常,请检查 " >SYSCHK_VIOS_AIX_SEA_Priority_RES.out
fi