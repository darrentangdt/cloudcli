#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_USRSEC_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年 1月15日
# 功  能：检查用户安全设置
# 复核人：
#************************************************#
export LANG=ZH_CN.UTF-8
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
	 :
	else
	exit 0
fi
#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOS_AIX_USRSEC_RES.out
for user in `lsuser -c -a ALL|grep -v ^#|grep -v root|grep -v padmin|grep -v patrol`
	do
	for chk in maxage pwdwarntime loginretries histsize minlen minalpha minother
		do
		lssec -f /etc/security/user -s ${user} -a ${chk}|awk '{print $2}'
		done
	done|sort|uniq >1.txt

for user_1 in root padmin
	do
	for chk_1 in maxage pwdwarntime loginretries histsize minlen minalpha minother
		do
		lssec -f /etc/security/user -s ${user_1} -a ${chk_1}|awk '{print $2}'
		done
	done|sort|uniq >2.txt

for chk_2 in maxage pwdwarntime loginretries histsize minlen minalpha minother
	do
	lssec -f /etc/security/user -s patrol -a ${chk_2}|awk '{print $2}'
	done|sort >3.txt

if diff 1.txt d_1.txt >ck1 2>&1 && diff 2.txt d_2.txt >ck2 2>&1 && diff 3.txt d_3.txt >ck3 2>&1
	then
		echo "Compliant"
		echo "正常" >${logfile}
			else
	 echo "Non-Compliant"
	 echo "异常,存在不合规的用户安全配置,请检查 " >${logfile}
fi