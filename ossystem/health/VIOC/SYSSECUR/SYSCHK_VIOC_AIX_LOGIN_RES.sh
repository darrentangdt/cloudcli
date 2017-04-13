#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_LOGIN_RES.sh            #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:判断当前用户连接数                      #
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

#判断当前用户连接数
v_lognum=`who |wc -l`
v_p1=`grep "V_AIX_HEA_LINKNUM" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_lognum -gt "$v_p1" ]; then
   echo "Non-Compliant"
   echo "异常,当前登录到主机的用户数为[$v_lognum]" > SYSCHK_VIOC_AIX_LOGIN_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_VIOC_AIX_LOGIN_RES.out

fi


exit 0;