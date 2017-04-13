#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_PASSINTENSITY_RES.sh	         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                             
# 功  能：检查密码强度策略                                                     
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

if [ -f SECAUD_LINUX_PASSINTENSITY_RES.out ]; then
	rm -f SECAUD_LINUX_PASSINTENSITY_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f temp.out ]; then
	rm -f temp.out
fi

if [ -f temp1.out ]; then
	rm -f temp1.out
fi

#1.检查密码强度策略，将空格分隔的结果依次输出到新文件中，对新文件进行分析.
echo 原始信息>SECAUD_LINUX_PASSINTENSITY_RES.out
echo ----->>SECAUD_LINUX_PASSINTENSITY_RES.out
awk -F " " '$1~/password/ && $2~/requisite/ {print $0}' /etc/pam.d/system-auth>>SECAUD_LINUX_PASSINTENSITY_RES.out
awk -F " " '$1~/password/ && $2~/requisite/ {print $0}' /etc/pam.d/system-auth>temp.out

awk '{for(i=1;i<=NF;i++){print $i}}' temp.out >temp1.out

#2.逐个查询minlen,minclass

echo ----->>SECAUD_LINUX_PASSINTENSITY_RES.out
echo 中间信息>>SECAUD_LINUX_PASSINTENSITY_RES.out
echo ----->>SECAUD_LINUX_PASSINTENSITY_RES.out

#3.若搜索不到该参数，返回的长度为1，判断长度大于1的返回后再判断其值是否合规
minlen=`cat temp1.out|grep "minlen"|awk -F "=" '{print $2}'`
v_minlen_value=`cat $v_golbalpath/LINUX_SEC_PARA.txt|grep V_LINUX_SEC_PASSINTENSITY_minlen|awk -F "=" '{print $2}'`
len_minlen=`echo "$minlen"|wc -c`
if [ "$len_minlen" -le 1 ]; then
	echo MINLEN未设置，不合规>>SECAUD_LINUX_PASSINTENSITY_RES.out
	echo MINLEN未设置，不合规>>Conviction.out
else
	if [ "$minlen" -ge "$v_minlen_value" ]; then
		echo MINLEN设置合规>>SECAUD_LINUX_PASSINTENSITY_RES.out
	else
		echo MINLEN设置的值不合规>>SECAUD_LINUX_PASSINTENSITY_RES.out
		echo MINLEN设置的值不合规>>Conviction.out
	fi
fi

minclass=`cat temp1.out|grep "minclass"|awk -F "=" '{print $2}'`
v_minlen_value=`cat $v_golbalpath/LINUX_SEC_PARA.txt|grep V_LINUX_SEC_PASSINTENSITY_minclass|awk -F "=" '{print $2}'`
len_minclass=`echo "$minclass"|wc -c`
if [ "$len_minclass" -le 1 ]; then
	echo MINCLASS未设置，不合规>>SECAUD_LINUX_PASSINTENSITY_RES.out
	echo MINCLASS未设置，不合规>>Conviction.out
else
	if [ "$minclass" -ge "$v_minlen_value" ]; then
		echo MINCLASS设置合规>>SECAUD_LINUX_PASSINTENSITY_RES.out
	else
		echo MINCLASS设置的值不合规>>SECAUD_LINUX_PASSINTENSITY_RES.out
		echo MINCLASS设置的值不合规>>Conviction.out
	fi
fi

echo ----->>SECAUD_LINUX_PASSINTENSITY_RES.out
echo 最终结果>>SECAUD_LINUX_PASSINTENSITY_RES.out
echo ----->>SECAUD_LINUX_PASSINTENSITY_RES.out

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#2.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "不合规">> SECAUD_LINUX_PASSINTENSITY_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_LINUX_PASSINTENSITY_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_LINUX_PASSINTENSITY_RES.out
fi

#3.删除临时文件.
if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f temp.out ]; then
	rm -f temp.out
fi

if [ -f temp1.out ]; then
	rm -f temp1.out
fi


exit 0;