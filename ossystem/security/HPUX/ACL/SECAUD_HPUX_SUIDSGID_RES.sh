#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_SUIDSGID_RES.sh             
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查设置了SUID、SGID的文件（人工）     
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_SUIDSGID_RES.out"
> $v_logfile


[ -f  Conviction.out ] && rm -f  Conviction.out
sh /home/ap/opsware/agent/scripts/SECURITY/HPUX/ACL/SECAUD_HPUX_SUIDSGID_TM.sh & 

#检查小于500G的文件系统
v_files=$(bdf|grep %|grep -iv Used|awk '{if ($(NF-4)<500000000) print $NF}')
for file in $v_files;do
	
	find $file -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -lrt {} \; >> Conviction.out 2>/dev/null 
done
test -f Conviction.out && line=`cat Conviction.out|wc -l`
if [ -f Conviction.out ];then
	if [ $line -gt 20 ];then
			echo 发现系统存在设置了SUID、SGID的文件，信息过多，仅列举前20行，参考如下:>>$v_logfile
		head -20 Conviction.out >> $v_logfile
	else 
		Conviction.out >> $v_logfile
	fi
fi
echo "Log"
[ -f  Conviction.out ] && rm -f  Conviction.out
