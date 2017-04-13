#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_NOOWNER_RES.sh             
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查无主文件                           
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_NOOWNER_RES.out"
> $v_logfile


[ -f  Conviction.out ] && rm -f  Conviction.out
sh /home/ap/opsware/agent/scripts/SECURITY/HPUX/ACL/SECAUD_HPUX_NOOWNER_TM.sh &  
#检查小于500G的文件系统
v_files=$(bdf|grep %|grep -iv Used|awk '{if ($(NF-4)<500000000) print $NF}')
if [ "$SECONDS" -lt 60 ]
 then
for file in $v_files;do
	find $file -xdev \( -nouser -o -nogroup \) -exec ls -lrt {} \;>> Conviction.out 2>/dev/null 
	if [ $? -ne 0 ];then
		echo "$file 目录中有以上无主文件:" >>Conviction.out
	fi
done
 else
  echo "查询超时,请手工执行 find / -nouser -o -nogroup 确认" >> Conviction.out
 break
 fi

#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#3.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo 发现系统存在无主文件，信息过多，仅列举前20行，参考如下:>>$v_logfile
		head -20 Conviction.out >> $v_logfile
		echo "Non-Compliant"
		echo "不合规" >> $v_logfile
	else
		echo "Compliant"
		echo "合规" >> $v_logfile
	fi
else 
	echo "Compliant"
	echo "合规" >> $v_logfile
fi

[ -f  Conviction.out ] && rm -f  Conviction.out

exit 0;
