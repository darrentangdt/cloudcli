#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_PWCK_RES.sh         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                            
# 功  能：利用pwck指令检查用户认证信息的完整性    
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

resulta=0
v_logfile="SECAUD_LINUX_PWCK_RES.out"
>$v_logfile

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f Conviction1.out ]; then
	rm -f Conviction1.out
fi

#1、利用pwck检查用户本地口令认证信息是否完整

pwck -r  /etc/passwd|grep user >/dev/null > Conviction.out 2>&1
v_users=$(awk -F: '{print substr($1,6)}' Conviction.out)
for v_user in $v_users;do
       grep ^$v_user /etc/passwd|grep -v nologin >/dev/null
       if [ $? -eq 0 ];then
       resulta=`echo \`expr $resulta + 1\``
       echo $v_user >>Conviction1.out
       fi
done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
echo "检查用户本地口令认证信息(pwck)" > $v_logfile
echo "合规">>SECAUD_LINUX_PWCK_RES.out
else 
echo "Non-Compliant"
echo "检查用户本地口令认证信息(pwck)" > $v_logfile
echo "不合规,以下用户未设置为nologin并且本地口令认证信息不完整">>$v_logfile
cat Conviction1.out>>SECAUD_LINUX_PWCK_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f Conviction1.out ]; then
	rm -f Conviction1.out
fi

exit 0;
