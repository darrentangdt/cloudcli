#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_FAILLOGIN_RES.sh        #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查失败登录可疑ip次数                  #
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
log_file=SYSCHK_VIOC_AIX_FAILLOGIN_RES.out

v_date=`date +%b\ %d`
v_p1=`grep "V_AIX_HEA_FALOGNUM" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ -f /etc/security/failedlogin ]; then
who /etc/security/failedlogin |tail -200 |grep "$v_date" |awk '{print $6}' |uniq -c |awk '( $1 > '"$v_p1"' ) {print $0}' > ${log_file}

if [ -s SYSCHK_VIOC_AIX_FAILLOGIN_RES.out ]; then
echo "Non-Compliant"
echo " 异常,今日有多于[$v_p1]次的登录失败记录 > [$v_p1] " > ${log_file}

else
echo "Compliant"
echo "正常" > ${log_file}
fi
else
echo "Non-Compliant"
echo " 异常,系统文件/etc/security/failedlogin不存在" > ${log_file}
fi

exit 0;