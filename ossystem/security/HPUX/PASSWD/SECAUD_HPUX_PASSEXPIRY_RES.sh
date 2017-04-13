#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_PASSEXPIRY_RES.sh          
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ����������Ч�ڲ���                     
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_PASSEXPIRY_RES.out"
> $v_logfile

[ -f  Conviction.out ] && rm -f  Conviction.out

if [ -f /etc/default/security ];then 
#1.����ʹ������Ӧ����60�죨root�����趨��
	v_maxday=$(cat /etc/default/security|grep -v root|grep -v  ^[[:space:]]*#|grep PASSWORD_MAXDAYS |awk -F"=" '{print $2}')
   [ -z "$v_maxday" ] && v_maxday="0"
	if [ $v_maxday =  60 ];then
           echo "�����ʹ�����޵���60���Ϲ�">> $v_logfile
	else
     	   echo "�����ʹ�����޲���δ����Ϊ60�����Ϲ�">> Conviction.out
	fi

#2.������뵽������ʱ��Ӧ����7��
	v_warnday=$(cat /etc/default/security|grep -v root|grep -v  ^[[:space:]]*#|grep PASSWORD_WARNDAY |awk -F"=" '{print $2}')
   [ -z "$v_warnday" ] && v_warnday="0"
	if [ $v_warnday =  7 ];then
           echo "���뵽������ʱ�����7�죬�Ϲ�">> $v_logfile
	else
     	   echo "���뵽������ʱ�����δ����Ϊ7�죬���Ϲ�">> Conviction.out
	fi

    if [ -s  Conviction.out ];then
   	echo "Non-Compliant"
  	cat Conviction.out >> $v_logfile
    else
        echo "Compliant"
        echo "�Ϲ�" >> $v_logfile
    fi
else
    echo "Non-Compliant"
    echo "���Ϲ棬����δ����������Ч�ڲ��� " >> $v_logfile
fi
[ -f  Conviction.out ] && rm -f  Conviction.out
