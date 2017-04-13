#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_Ent_Speed_RES.sh  			 #
# 作  者:iomp_zcw		                             #
# 日  期:2014年 1月15日                          #
# 功  能:ENT速率检查	         								 	 #
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
logfile=SYSCHK_VIOS_AIX_Ent_Speed_RES.out
>${logfile}
#ENT速率检查

for ent_s in ent15 ent16 ent17
	do
		if [ `entstat -d ${ent_s} 2>/dev/null|awk '/Media Speed Running/{print $4}'|sort|uniq` -ne 10 ]
			then
			let abc=${abc}+1
			echo "${ent_s}网卡速率不是10G" >>${logfile}
		fi
	done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,存在速率不为10G的网卡,请检查" >>${logfile}
	fi