#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_SUIDSGID_TM.sh             
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ����������SUID��SGID���ļ����˹���     
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
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
echo �ű����г�ʱ�����ֹ����>>Conviction.out 
else
break
fi
done
