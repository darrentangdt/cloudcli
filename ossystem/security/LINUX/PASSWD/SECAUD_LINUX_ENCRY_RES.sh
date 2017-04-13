#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_ENCRY_RES.sh	         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                            
# 功  能：检查是否密码加密算法强度是否足够(人工)             
#************************************************

v_golbalpath=/home/ap/opscloud/security/LINUX
#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/security/LINUX"
log_dir="/home/ap/opscloud/logs"
cd ${log_dir} >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir ${log_dir} 
  cd ${log_dir}
fi

v_logfile="SECAUD_LINUX_ENCRY_RES.out"
>$v_logfile


#1.检查加密算法是否为sha256或sha512
cat /etc/pam.d/system-auth|grep "password    sufficient"|grep -v  ^[[:space:]]*#|grep -Ei 'sha256|sha512' >/dev/null 2>&1
if [ $? -eq 0 ];then
  cat /etc/shadow | awk -F: '$2!~/!!/ {print $0}'|awk -F: '$2!~/*/ {print $0}'|awk -F: 'substr($2,1,2)!~/\$5|\$6/'>Conviction.out
  test -f Conviction.out && line=`cat Conviction.out | wc -l`
  [ -z "$line" ] && line="0"
	if [ $line -gt 0 ]; then
		echo "不合规,以下用户口令加密算法强度不够:">>$v_logfile
		cat Conviction.out >> $v_logfile
		echo "Non-Compliant"
	else
		echo "Compliant"
		echo "合规" >> $v_logfile
	fi
else
  echo "Non-Compliant"
  echo "不合规,口令加密算法未配置为sha256或sha512" >> $v_logfile
fi

exit 0;
