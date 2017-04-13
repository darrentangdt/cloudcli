#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_PATROLID_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查patrol用户ID                       #
# 复核人：                                       #
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
logfile=SYSAUD_VIOC_AIX_PATROLID_RES.out

v_id=`cat /etc/passwd |awk -F: '($1 == "patrol") {print $3}'`
v_p1=911

if [ -n "$v_id" ]; then
if [ $v_id -eq "$v_p1" ];
then
echo "Compliant"
echo "正常" > ${logfile}
else
echo "Non-Compliant"
echo "异常,本机patrol用户ID为[$v_id],用户ID设置未设置为[$v_p1],属不合规" > ${logfile}
fi
else
echo "Compliant"
echo "正常" > ${logfile}
fi