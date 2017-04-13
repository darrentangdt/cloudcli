#!/bin/sh
#************************************************
# 文件名：SECAUD_LINUX_FILECHK_RES.sh            
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                             
# 功  能：检查命令解释器文件权限                                    
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

if [ -f SECAUD_LINUX_FILECHK_RES.out ]; then
	rm -f SECAUD_LINUX_FILECHK_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

echo 原始信息>SECAUD_LINUX_FILECHK_RES.out
echo ----->>SECAUD_LINUX_FILECHK_RES.out
echo 权限及属主信息:>>SECAUD_LINUX_FILECHK_RES.out

#检查单个文件
filelist=`grep F\| $v_golbalpath/LINUX_SEC_PARA.txt| awk -F\| '{print $2}'`
for i in $filelist; do
ls -al $i >>SECAUD_LINUX_FILECHK_RES.out
ls -al $i|awk '{print $NF"|"$3"|"$4"|"$1}'>>temp.out
done
#检查某一目录下文件
pathlist=`grep D1\| $v_golbalpath/LINUX_SEC_PARA.txt| awk -F\| '{print $2}'`
echo $pathlist 目录下文件 >>SECAUD_LINUX_FILECHK_RES.out
ls -l $pathlist|grep -v 总计|grep -v total >>SECAUD_LINUX_FILECHK_RES.out
ls -l $pathlist|grep -v 总计|grep -v total|awk '{print "D1""|"$NF"|"$3"|"$4"|"$1}'>>temp1.out


echo ----->>SECAUD_LINUX_FILECHK_RES.out
echo 中间信息>>SECAUD_LINUX_FILECHK_RES.out
echo ----->>SECAUD_LINUX_FILECHK_RES.out

echo 以下文件权限、属主不合规 >>SECAUD_LINUX_FILECHK_RES.out
#列出不合规的单个文件
for i in `cat temp.out`;do
var1=`echo $i|awk -F\| '{print "F""|"$1"|"$2"|"$3}'`
attr=`echo $i|awk -F\| '{print $4}'`
attrsys=`grep $var1 $v_golbalpath/LINUX_SEC_PARA.txt|awk -F\| '{print $5}'`
echo "$attrsys"|grep -q ".$attr"
if [ $? -eq 0 ]; then
echo nothing>/dev/null 2>&1
else 
echo "$i"|awk -F\| '{print $1}'  >>SECAUD_LINUX_FILECHK_RES.out
echo "$i"|awk -F\| '{print $1}' >>Conviction.out
fi
done

#列出目录下不合规文件(判断依据文件名等于属主、权限、属组为root)
for i in `cat temp1.out`;do
pathlist=`grep D1\| $v_golbalpath/LINUX_SEC_PARA.txt| awk -F\| '{print $2}'`
#var2=`echo $i|awk -F\| '{print "D1""|"$1"|"}'`
ower=`echo $i|awk -F\| '{print $4}'`
group=`echo $i|awk -F\| '{print $4}'`
attr=`echo $i|awk -F\| '{print $5}'`
groupsys=`grep D1 $v_golbalpath/LINUX_SEC_PARA.txt|awk -F\| '{print $4}'`
attrsys=`grep D1 $v_golbalpath/LINUX_SEC_PARA.txt|awk -F\| '{print $5}'`
echo "$attrsys"|grep -q ".$attr"
if [ $? -eq 0 ]&& [ "$groupsys" = "$group" ]&&[ "`echo $i|awk -F\| '{print $2}'`" = "`echo $i|awk -F\| '{print $3}'`" ];then
echo nothing>/dev/null 2>&1
else
echo $pathlist"/"`echo "$i"|awk -F\| '{print $2}'` >>SECAUD_LINUX_FILECHK_RES.out
echo $pathlist"/"`echo "$i"|awk -F\| '{print $2}'` >>Conviction.out
fi
done

echo ----->>SECAUD_LINUX_FILECHK_RES.out
echo 最终结论>>SECAUD_LINUX_FILECHK_RES.out
echo ----->>SECAUD_LINUX_FILECHK_RES.out

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#3.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "不合规" >> SECAUD_LINUX_FILECHK_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_LINUX_FILECHK_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_LINUX_FILECHK_RES.out
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

exit 0;