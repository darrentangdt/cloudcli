#!/bin/sh
#************************************************#
# 文件名：SECAUD_AIX_PWCK_RES.sh                 
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日  
# 功  能：检查用户认证信息的完整性               
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

>SECAUD_AIX_PWCK_RES.out

pwdck -n ALL >/dev/null 2>&1
if [ $? -eq 0 ]; then
echo "Compliant" 
echo "合规">SECAUD_AIX_PWCK_RES.out
else
pwdck -n ALL 2>SECAUD_AIX_PWCK_RES1.out
cat ${log_dir}/SECAUD_AIX_PWCK_RES1.out|awk -F"\"" '{print $2}'|uniq| while read v_ss
do
 set $v_ss
 lssec -f /etc/security/user -s $v_ss -a login|grep true>/dev/null 2>&1
 v_result=`echo $?`
    if [ "$v_result" -eq 0 ];then  
echo "$v_ss 用户认证信息不完整">>SECAUD_AIX_PWCK_RES2.out
fi
done

fi

if [ -s SECAUD_AIX_PWCK_RES2.out ];then
    echo "Non-Compliant"
echo "不合规" >> SECAUD_AIX_PWCK_RES.out
cat SECAUD_AIX_PWCK_RES2.out >>SECAUD_AIX_PWCK_RES.out
else
    echo "Compliant"
echo "合规" >> SECAUD_AIX_PWCK_RES.out
fi
rm -f SECAUD_AIX_PWCK_RES1.out
rm -f SECAUD_AIX_PWCK_RES2.out
