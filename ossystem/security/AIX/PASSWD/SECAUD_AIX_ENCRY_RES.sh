#!/bin/sh
#*************************************************#
# 文件名：SECAUD_AIX_ENCRY_RES.sh                 
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日  
# 功  能：检查是否选择高强度的密码加密算法（人工）
#*************************************************#

v_golbalpath=/home/ap/opscloud/security/AIX
#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/security/AIX"
log_dir="/home/ap/opscloud/logs"
cd ${log_dir} >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir ${log_dir} 
  cd ${log_dir}
fi

v_logfile="SECAUD_AIX_ENCRY_RES.out"

> $v_logfile

v_encry=`cat /etc/security/login.cfg |grep -v  ^[[:space:]]*#| grep "pwd_algorithm ="|awk '{print $NF}'`

if [ EOF$v_encry = EOF ]; then
	echo "Non-Compliant" 
	echo "当前用户密码设置的加密算法为cyrpt()，不合规">SECAUD_AIX_ENCRY_RES.out
	elif [ $v_encry = 'ssha256' ] || [ $v_encry = 'ssha512' ] ; then
  echo "Compliant"
	echo "当前用户密码设置的加密算法为$v_encry,合规">SECAUD_AIX_ENCRY_RES.out
else 
	echo "Non-Compliant"
	echo "当前用户密码设置的加密算法为$v_encry,不合规">SECAUD_AIX_ENCRY_RES.out
fi
