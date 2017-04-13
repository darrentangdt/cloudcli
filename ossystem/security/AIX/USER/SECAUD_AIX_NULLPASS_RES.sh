#!/bin/sh
#************************************************
# 文件名：SECAUD_AIX_NULLPASS_RES.sh	         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                             
# 功  能：检查用户空口令情况	                                                       
#************************************************

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

if [ -f SECAUD_AIX_NULLPASS_RES.out ]; then
	rm -f SECAUD_AIX_NULLPASS_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

#1.检查用户空口令情况.
echo "原始信息："> SECAUD_AIX_NULLPASS_RES.out
echo "-----">> SECAUD_AIX_NULLPASS_RES.out
echo "系统中用户列表为：">> SECAUD_AIX_NULLPASS_RES.out
logins|awk '{print $1}'>>SECAUD_AIX_NULLPASS_RES.out

echo ----->>SECAUD_AIX_NULLPASS_RES.out
echo 中间结果>>SECAUD_AIX_NULLPASS_RES.out
echo ----->>SECAUD_AIX_NULLPASS_RES.out
echo "以下用户为空口令用户：">> SECAUD_AIX_NULLPASS_RES.out
logins -p|awk '{print $1}'>Conviction.out

#2.得到最终结果.

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#2.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		cat Conviction.out >> SECAUD_AIX_NULLPASS_RES.out
		echo "-----">> SECAUD_AIX_NULLPASS_RES.out
		echo "最终结论：">>SECAUD_AIX_NULLPASS_RES.out
		echo "-----">> SECAUD_AIX_NULLPASS_RES.out
		echo "不合规">> SECAUD_AIX_NULLPASS_RES.out
	else
		echo "Compliant"
		echo "-----">> SECAUD_AIX_NULLPASS_RES.out
		echo "最终结论：">>SECAUD_AIX_NULLPASS_RES.out
		echo "-----">> SECAUD_AIX_NULLPASS_RES.out
		echo "合规" >> SECAUD_AIX_NULLPASS_RES.out
	fi
else 
	echo "Compliant"
	echo "-----">> SECAUD_AIX_NULLPASS_RES.out
	echo "最终结论：">>SECAUD_AIX_NULLPASS_RES.out
	echo "-----">> SECAUD_AIX_NULLPASS_RES.out
	echo "合规" >> SECAUD_AIX_NULLPASS_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

exit 0;
