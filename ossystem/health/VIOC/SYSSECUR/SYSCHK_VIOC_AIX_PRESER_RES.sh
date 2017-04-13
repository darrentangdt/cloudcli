#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_PRESER_RES.sh           #
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

v_size=`du -sm /var/preserve |awk '{print $1}'`
v_p1=`grep "V_AIX_HEA_PRESSIZE" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_size -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "异常,/var/preserve目录空间为[$v_size]M,已超过阈值" > SYSCHK_VIOC_AIX_PRESER_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_VIOC_AIX_PRESER_RES.out

    
fi

exit 0;