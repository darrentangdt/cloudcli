#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_PHYENTPARAM_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:物理网卡参数值检查
# 复核人:
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
logfile=SYSAUD_VIOS_AIX_PHYENTPARAM_RES.out
>${logfile}
for ent in ent0 ent1 ent2 ent3 ent4 ent5
	do
	if [ `lsattr -El ${ent}|awk '/flow_ctrl/{print $2}'` = yes ]&&[ `lsattr -El ${ent}|awk '/large_send/{print $2}'` = yes ]&&[ `lsattr -El ${ent}|awk '/large_receive/{print $2}'` = yes ]
		then
			:
		else
			let abc=${abc}+1
			echo "${ent}参数设置不合规" >> ${logfile}
		fi
		done
	if [ ${abc} -eq 0 ]
		then
			echo "Compliant"
			echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常,有物理网卡参数值设置异常,请检查" >>${logfile}
	fi