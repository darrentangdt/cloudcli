#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_SUIDSGID_RES.sh             
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

v_logfile="SECAUD_HPUX_SUIDSGID_RES.out"
> $v_logfile


[ -f  Conviction.out ] && rm -f  Conviction.out
sh /home/ap/opsware/agent/scripts/SECURITY/HPUX/ACL/SECAUD_HPUX_SUIDSGID_TM.sh & 

#���С��500G���ļ�ϵͳ
v_files=$(bdf|grep %|grep -iv Used|awk '{if ($(NF-4)<500000000) print $NF}')
for file in $v_files;do
	
	find $file -xdev -type f \( -perm -4000 -o -perm -2000 \) -exec ls -lrt {} \; >> Conviction.out 2>/dev/null 
done
test -f Conviction.out && line=`cat Conviction.out|wc -l`
if [ -f Conviction.out ];then
	if [ $line -gt 20 ];then
			echo ����ϵͳ����������SUID��SGID���ļ�����Ϣ���࣬���о�ǰ20�У��ο�����:>>$v_logfile
		head -20 Conviction.out >> $v_logfile
	else 
		Conviction.out >> $v_logfile
	fi
fi
echo "Log"
[ -f  Conviction.out ] && rm -f  Conviction.out
