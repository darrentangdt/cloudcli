#!/bin/sh
#************************************************#
# 文件名：SECAUD_AIX_UNIQUID_RES.sh              
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日  
# 功  能：检查是否存在重复的UID                  
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


v_uid1=`cat /etc/passwd|awk -F: '{print $3}'|uniq -d`
if [ -z "$v_uid1" ]; then
echo "Compliant"
echo "合规" >SECAUD_AIX_UNIQUID_RES.out
else
echo "Non-Compliant"
echo "不合规" >SECAUD_AIX_UNIQUID_RES.out
for v_uid in $v_uid1;do
cat /etc/passwd|awk -F: -v v_uid2="$v_uid"  '{if ( $3==v_uid2 ) print $0}'>>SECAUD_AIX_UNIQUID_RES.out
done
fi