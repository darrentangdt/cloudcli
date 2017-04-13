 #!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_LOCALACL_RES.sh             
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                             
# 功  能：检查本次初始化文件权限(人工)                                     
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


if [ -f SECAUD_LINUX_LOCALACL_RES.out ]; then
	rm -f SECAUD_LINUX_LOCALACL_RES.out
fi

echo 原始信息>SECAUD_LINUX_LOCALACL_RES.out
echo ----->>SECAUD_LINUX_LOCALACL_RES.out
echo 权限及属主信息:>>SECAUD_LINUX_LOCALACL_RES.out
#获取系统有效账户
userlist=`cat /etc/shadow |grep -v \!\! |grep -v \*\:|awk -F: '{print $1}'`
for i in $userlist;do
    dir=`grep ^$i: /etc/passwd|awk -F: '{print $6}'`
		FILES=`cat $v_golbalpath/LINUX_SEC_PARA.txt |grep U1|awk -F\| '{print $2}'`
		for file in $FILES; do
		test -f $dir/$file && ls -la $dir/$file | awk '{print $1,"\t",$3,"\t",$4,"\t",$9}' >> SECAUD_LINUX_LOCALACL_RES.out 
		owner=`test -f $dir/$file &&ls -la $dir/$file | awk '{print $3}'`
		group=`test -f $dir/$file &&ls -la $dir/$file | awk '{print $4}'`
		attr=`test -f $dir/$file &&ls -la $dir/$file | awk '{print $1}'`
		groupid=`grep ^$owner: /etc/passwd|awk -F: '{print $4}'`
		groupsys=`grep :$groupid: /etc/group|awk -F: '{print $1}'`
		attrsys=`cat $v_golbalpath/LINUX_SEC_PARA.txt |grep U1|grep $file |awk -F\| '{print $5}'`
		echo "$attrsys"|grep -q ".$attr"
		if [ $? -eq 0 ]&&[ "$owner" = "$i" ]&&[ "$groupsys" = "$group" ];then
		echo nothing>/dev/null 2>&1
    else
    test -f $dir/$file && ls -la $dir/$file >>Conviction.out
    fi
	  done
#	done
done
 
echo ----->>SECAUD_LINUX_LOCALACL_RES.out
echo 中间信息>>SECAUD_LINUX_LOCALACL_RES.out
echo ----->>SECAUD_LINUX_LOCALACL_RES.out
echo 以下文件属主、权限不合规>>SECAUD_LINUX_LOCALACL_RES.out
test -f Conviction.out && cat Conviction.out >> SECAUD_LINUX_LOCALACL_RES.out 

echo ----->>SECAUD_LINUX_LOCALACL_RES.out
echo 最终结论>>SECAUD_LINUX_LOCALACL_RES.out
echo ----->>SECAUD_LINUX_LOCALACL_RES.out

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#3.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "不合规" >> SECAUD_LINUX_LOCALACL_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_LINUX_LOCALACL_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_LINUX_LOCALACL_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

exit 0;
