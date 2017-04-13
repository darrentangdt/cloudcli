#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_SULOGSIZE_RES.sh        #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查登陆日志大小                        #
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

if [ -f /var/adm/sulog ]; then
v_size=`ls -l /var/adm/sulog |awk '{print $5}'`
v_p1=`grep "V_AIX_HEA_SULOGSIZE" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_size -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "异常,sulog文件大小[$v_size]byte,已超过阈值" > SYSCHK_VIOC_AIX_SULOGSIZE_RES.out
else
    echo "Compliant"
     echo "正常" > SYSCHK_VIOC_AIX_SULOGSIZE_RES.out

fi
else
    echo "Non-Compliant"
    echo " 异常,系统文件/var/adm/sulog不存在" > SYSCHK_VIOC_AIX_SULOGSIZE_RES.out
fi

exit 0;