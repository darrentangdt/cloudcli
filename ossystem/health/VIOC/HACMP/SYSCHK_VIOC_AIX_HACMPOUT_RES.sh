#!/bin/sh
#************************************************#
# 文件名：SYSCHK_VIOC_AIX_HACMPOUT_RES.sh        #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2010年 1月4 日                         #
# 功  能：检查hacmp日志是否报错                  #
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


v_p1=`grep "V_AIX_HEA_KEY1" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_HEA_KEY2" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

lssrc -g cluster |grep "clstrmgrES" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
if [ -s SYSCHK_VIOC_AIX_HACMPOUT_RES.out ]; then
if [ -s /tmp/hacmp.out ]
then
tail -20 /tmp/hacmp.out |grep -E "$v_p1|$v_p2" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
elif [ -s /var/hacmp/log/hacmp.out ]
then
tail -20 /var/hacmp/log/hacmp.out |grep -E "$v_p1|$v_p2" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
else
cat /dev/null > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi

if [ -s SYSCHK_VIOC_AIX_HACMPOUT_RES.out ]
then
echo "Non-Compliant"
echo "异常,hacmp.out有错误日志" >> SYSCHK_VIOC_AIX_HACMPOUT_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi
else
echo "Compliant"
echo "正常" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi

exit 0;