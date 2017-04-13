#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_NOOWNER_RES.sh             
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ���������ļ�                           
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
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
#���С��500G���ļ�ϵͳ
v_files=$(bdf|grep %|grep -iv Used|awk '{if ($(NF-4)<500000000) print $NF}')
if [ "$SECONDS" -lt 60 ]
 then
for file in $v_files;do
	find $file -xdev \( -nouser -o -nogroup \) -exec ls -lrt {} \;>> Conviction.out 2>/dev/null 
	if [ $? -ne 0 ];then
		echo "$file Ŀ¼�������������ļ�:" >>Conviction.out
	fi
done
 else
  echo "��ѯ��ʱ,���ֹ�ִ�� find / -nouser -o -nogroup ȷ��" >> Conviction.out
 break
 fi

#���ܳ���û��Υ������Ҳ����Conviction�ļ�����������ͨ�����ص��������ж��Ƿ���Υ������
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#3.����Conviction���ڲ���������Ϊ0���õ����ս��.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo ����ϵͳ���������ļ�����Ϣ���࣬���о�ǰ20�У��ο�����:>>$v_logfile
		head -20 Conviction.out >> $v_logfile
		echo "Non-Compliant"
		echo "���Ϲ�" >> $v_logfile
	else
		echo "Compliant"
		echo "�Ϲ�" >> $v_logfile
	fi
else 
	echo "Compliant"
	echo "�Ϲ�" >> $v_logfile
fi

[ -f  Conviction.out ] && rm -f  Conviction.out

exit 0;
