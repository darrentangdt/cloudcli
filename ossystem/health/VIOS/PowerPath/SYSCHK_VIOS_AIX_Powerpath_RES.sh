#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_Powerpath_RES.sh  			 #
# 作  者:iomp_zcw		                             #
# 日  期:2014年 1月15日                          #
# 功  能:powerpath检查	       								 	 #
# 复核人:                                        #
#************************************************#
abc=0
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

#powerpath检查

for disk_name in `lspv|awk '/power/{print $1}'`
	do
	fcs_c=`powermt display dev=${disk_name}|awk 'NR>8 {print $2}'|sed '/^$/d'|wc -l`
	alive_c=`powermt display dev=${disk_name}|awk 'NR>8 {print $7}'|sed '/^$/d'|sort|uniq|grep -v alive|wc -l`
		if [ ${fcs_c} -ne 4 ] || [ ${alive_c} -ne 0 ]
			then
				let abc=${abc}+1
				fi
				done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >SYSCHK_VIOS_AIX_Powerpath_RES.out
		else
		echo "Non-Compliant"
		echo "异常,存在单链路或存在不为alive状态的路径,请检查" >SYSCHK_VIOS_AIX_Powerpath_RES.out
	fi