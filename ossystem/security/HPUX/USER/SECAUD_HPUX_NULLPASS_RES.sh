#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_NULLPASS_RES.sh            
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查是否存在空口令用户                 
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_NULLPASS_RES.out"
> $v_logfile

v_passwd=`logins -p|awk '{print $1}'`
if [ -z "$v_passwd" ]; then
	echo "Compliant"
	echo "合规" > $v_logfile
	else
	echo "Non-Compliant"
	echo "不合规" >$v_logfile
	echo "以下账户password域为空：" >>$v_logfile
	logins -p|awk '{print $1}' >>$v_logfile
fi