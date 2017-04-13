#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_SUIDSGID_TM.sh             
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
while :
do
sleep 30
v_num=$(ps -ef|grep '\-xdev -type f ( -perm -4000 -o -perm -2000 )'|grep -v grep|awk '{print $2}')
 
[ -z "$v_num" ] && v_num=0
if [ $v_num -gt 0 ];then
ps -ef|grep '\-xdev -type f ( -perm -4000 -o -perm -2000 )'|grep -v grep|awk '{print $2}'|xargs kill -9  2>/dev/null
echo 脚本运行超时，请手工检查>>Conviction.out 
else
break
fi
done
