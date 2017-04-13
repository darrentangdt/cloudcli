#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_SHADOW_RES.sh              
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ�����Ƿ�������shadow password          
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_SHADOW_RES.out"
> $v_logfile

[ -f  Conviction.out ] && rm -f  Conviction.out

if [ -f /etc/shadow ];then 
cat /etc/passwd |grep -v  ^[[:space:]]*#|grep sh$ |awk -F: '$2!~/x/ {print $1}'|uniq| while read v_ss
do
 set $v_ss
 grep $v_ss /etc/shadow >/dev/null 2>&1
 v_result=`echo $?`
    if [ "$v_result" -ne 0 ];then  
echo "$v_ss �û�δ����shadow password">>Conviction.out
fi
done
    if [ -s  Conviction.out ];then
   	echo "Non-Compliant"
  	cat Conviction.out >> $v_logfile
    else
        echo "Compliant"
        echo "�Ϲ�" >> $v_logfile
    fi
else
    echo "Non-Compliant"
    echo "���Ϲ棬����δ����shadow password" >> $v_logfile
fi
[ -f  Conviction.out ] && rm -f  Conviction.out

