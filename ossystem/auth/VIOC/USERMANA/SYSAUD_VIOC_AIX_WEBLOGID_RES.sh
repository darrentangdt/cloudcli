#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_WEBLOGID_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查weblogic用户ID                     #
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
logfile=SYSAUD_VIOC_AIX_WEBLOGID_RES.out

v_id=`cat /etc/passwd |awk -F: '($1 == "weblogic") {print $3}'`
v_p1=431
v_p2=439
if [ -n "$v_id" ]; then
if [[ $v_id -le "$v_p2" && $v_id -ge "$v_p1" ]];
then
echo "Compliant"
echo "正常" > ${logfile}
else
echo "Non-Compliant"
echo "异常,当前weblogic 用户ID为[$v_id],ID设置不在"$v_p1"至"$v_p2"之间,属不合规" > ${logfile}
fi
else
echo "Compliant"
echo "正常" > ${logfile}
fi




