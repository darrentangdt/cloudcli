#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_POWERERR_RES.sh         #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查电源故障信息是否在crontab中清除     #
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

crontab -l |grep "every 12" > /dev/null > SYSCHK_VIOC_AIX_POWERERR_RES.out 2>&1
if [ -s SYSCHK_VIOC_POWERERR_RES.out ]; then
    echo "Non-Compliant"
    echo "异常,crontab中存在电源故障的信息,请检查" > SYSCHK_VIOC_AIX_POWERERR_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_VIOC_AIX_POWERERR_RES.out
fi

exit 0;