#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_WTMP_RES.sh                 #
# 作  者:CCSD_YOUTONGLI                            #
# 日  期:2010年 1月4 日                         #
# 功  能:检查登陆日志大小                       #
# 复核人:                                       #
#************************************************#

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

#判断当前登录日志大小
if [ -f /var/adm/wtmp ]; then
v_size=`ls -l /var/adm/wtmp |awk '{print $5}'`
v_p1=`grep "V_AIX_HEA_WTMPSIZE" /home/ap/opscloud/health_check/VIOS/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_size -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "异常,wtmp文件大小[$v_size]byte,已超过阈值,请检查 " > SYSCHK_VIOS_AIX_WTMP_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_VIOS_AIX_WTMP_RES.out

fi
else
    echo "Non-Compliant"
    echo " 异常，/var/adm/wtmp文件不存在,请检查 " > SYSCHK_VIOS_WTMP_RES.out
fi

exit 0;