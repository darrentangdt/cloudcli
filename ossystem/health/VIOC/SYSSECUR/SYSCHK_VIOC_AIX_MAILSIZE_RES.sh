#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_MAILSIZE_RES.sh         #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查mail日志大小                        #
# 复核人:                                        #
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

v_p1=`grep "V_AIX_HEA_LOGSIZE" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ -d /var/spool/mail ]; then
v_num=`ls -l /var/spool/mail |awk '($5 > '"$v_p1"' ) {print $0}' |wc -l`
if [ $v_num -gt 0 ]; then
    echo "Non-Compliant"
    echo "异常,以下邮件文件大于阈值[$v_p1]byte" > SYSCHK_VIOC_AIX_MAILSIZE_RES.out
    ls -l /var/spool/mail |awk '($5 > '"$v_p1"') {print $0}' >> SYSCHK_VIOC_AIX_MAILSIZE_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_VIOC_AIX_MAILSIZE_RES.out

fi
else
     echo "Non-Compliant"
     echo "异常,/var/spool/mail文件目录不存在" > SYSCHK_VIOC_AIX_MAILSIZE_RES.out
fi

exit 0;