#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_NETCARD_RES.sh
# 作  者:CCSD_liyu
# 日  期:2012年 4月5日
# 功  能:检查网卡状态
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
cd /home/ap/opscloud/logs >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opscloud/logs
  cd /home/ap/opscloud/logs
fi

v_p1=`grep V_AIX_HEA_BACKUPNETCARD /home/ap/opscloud/health_check/VIOS/AIX_HEA_PARA.txt | awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="xxxlllyyy_lll"
lsdev -Cc if |grep "`netstat -in |awk '{print $1}' |grep en`" |awk '{ if ($2 != "Available") print $0}'|grep -Ev "$v_p1" > SYSCHK_VIOS_AIX_NETCARD_RES.out
if [ -s SYSCHK_VIOS_AIX_NETCARD_RES.out ]
then
echo "Non-Compliant"
lsdev -Cc if |grep "`netstat -in |awk '{print $1}' |grep en`" |awk '{ if ($2 != "Available") print $0}' >> SYSCHK_VIOS_AIX_NETCARD_RES.out
exit 0
else
for en_name in en15 en15 en17
	do
		en_C=`entstat -d ${en_name} 2>/dev/null|awk -F ":" '/Link Status/{print $2}'|grep -v Up|wc -l`

		if [ ${en_C} -ne 0 ]
			then
				let abc=${abc}+1
				echo "异常,${en_name}设置不合规" >> SYSCHK_VIOS_AIX_NETCARD_RES.out
fi
done
fi
if [ ${abc} -eq 0 ]
	then
		echo "Compliant"
		echo "正常" > SYSCHK_VIOS_AIX_NETCARD_RES.out
		else
		echo "Non-Compliant"
		echo "异常,存在非available状态的网卡" >> SYSCHK_VIOS_AIX_NETCARD_RES.out
fi
exit 0;