#!/bin/sh
#************************************************#
# 文件名： SECAUD_AIX_UMASK_RES.sh               
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日  
# 功  能：检查用户掩码                           
#************************************************#

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

>SECAUD_AIX_UMASK_RES.out
v_umask1=`cat /etc/security/user |grep -v "^*"|sed -n '/^default:/,/^root:/p'|grep umask|awk '{print $3}'`
if [ $v_umask1 != "022" ]; then
echo "ccb要求umask值为022，当前系统umask值为:$v_umask1;" >> SECAUD_AIX_UMASK_RES1.out
fi

v_umask2=`cat /etc/passwd|awk -F":" '{print $1}'`
for v_umask in $v_umask2 ;do
	v_umask3=`lssec -f /etc/security/user -s $v_umask -a umask|awk -F"=" '{print $NF}'`
	if [ $v_umask3 != 22 ];then
		echo "$v_umask 用户的umask值不为022，不合规"  >> SECAUD_AIX_UMASK_RES1.out
	fi
done

if [ -s "SECAUD_AIX_UMASK_RES1.out" ];then 
echo  "Non-Compliant"
cat SECAUD_AIX_UMASK_RES1.out >>SECAUD_AIX_UMASK_RES.out
else
echo "Compliant"
echo "合规">>SECAUD_AIX_UMASK_RES.out
fi
rm -f SECAUD_AIX_UMASK_RES1.out
		
