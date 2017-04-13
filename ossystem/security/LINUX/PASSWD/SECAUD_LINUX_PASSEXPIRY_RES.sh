#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_PASSEXPIRY_RES.sh	         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                               
# 功  能：检查密码有效期策略                                                   
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

if [ -f SECAUD_LINUX_PASSEXPIRY_RES.out ]; then
	rm -f SECAUD_LINUX_PASSEXPIRY_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

#1.检查是否开启了密码有效期策略.
echo "原始信息："> SECAUD_LINUX_PASSEXPIRY_RES.out
echo "-----">> SECAUD_LINUX_PASSEXPIRY_RES.out
awk -F " " '$1~/PASS_MAX_DAYS/ {print $0}' /etc/login.defs>>SECAUD_LINUX_PASSEXPIRY_RES.out
awk -F " " '$1~/PASS_WARN_AGE/ {print $0}' /etc/login.defs>>SECAUD_LINUX_PASSEXPIRY_RES.out

echo ----->>SECAUD_LINUX_PASSEXPIRY_RES.out
echo 中间信息>>SECAUD_LINUX_PASSEXPIRY_RES.out
echo ----->>SECAUD_LINUX_PASSEXPIRY_RES.out

v_pass_max_days=`grep "PASS_MAX_DAYS" /etc/login.defs |sed -n 2p |awk -F " " '{print $2}'`
v_pass_max_days_value=`cat $v_golbalpath/LINUX_SEC_PARA.txt|grep V_LINUX_SEC_PASSEXPIRY_PASS_MAX_DAYS|awk -F "=" '{print $2}'`
if [ "$v_pass_max_days" -le "$v_pass_max_days_value" ]; then
	echo PASS_MAX_DAYS设置合规>>SECAUD_LINUX_PASSEXPIRY_RES.out
else
	echo PASS_MAX_DAYS设置不合规>>SECAUD_LINUX_PASSEXPIRY_RES.out
	echo PASS_MAX_DAYS设置不合规>>Conviction.out
fi

v_pass_warn_age=`grep "PASS_WARN_AGE" /etc/login.defs |sed -n 2p |awk -F " " '{print $2}'`
v_v_pass_warn_age_value=`cat $v_golbalpath/LINUX_SEC_PARA.txt|grep V_LINUX_SEC_PASSEXPIRY_PASS_WARN_AGE|awk -F "=" '{print $2}'`
if [ "$v_pass_warn_age" -gt "$v_v_pass_warn_age_value" ]; then
	echo PASS_WARN_AGE设置合规>>SECAUD_LINUX_PASSEXPIRY_RES.out
else
	echo PASS_WARN_AGE设置不合规>>SECAUD_LINUX_PASSEXPIRY_RES.out
	echo PASS_WARN_AGE设置不合规>>Conviction.out
fi

#排除root用户和结尾为nologin的用户
v_users=$(cat /etc/passwd|grep -v ^root|grep -v nologin$|grep false$|awk -F: '{print $1}')
for v_user in $v_users;do
	v_user_max=$(chage -l $v_user|grep "Maximum number"|awk '{print $NF}')
	if [ $v_user_max = 60 ];then
           echo "$v_user 密码最大有效期为60天，合规">> SECAUD_LINUX_PASSEXPIRY_RES.out
	else
     	   echo "$v_user 密码最大有效期不为60天，不合规">> Conviction.out
     	   echo "$v_user 密码最大有效期不为60天，不合规">> SECAUD_LINUX_PASSEXPIRY_RES.out
	fi
done

echo ----->>SECAUD_LINUX_PASSEXPIRY_RES.out
echo 最终结果>>SECAUD_LINUX_PASSEXPIRY_RES.out
echo ----->>SECAUD_LINUX_PASSEXPIRY_RES.out

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#2.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "不合规">> SECAUD_LINUX_PASSEXPIRY_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_LINUX_PASSEXPIRY_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_LINUX_PASSEXPIRY_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi


exit 0;
