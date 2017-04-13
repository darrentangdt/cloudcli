#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_PASSINTENSITY_RESS.sh      
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ��������ǿ�Ȳ���                       
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_PASSINTENSITY_RES.out"
> $v_logfile

[ -f  Conviction.out ] && rm -f  Conviction.out


if [ -f /etc/default/security ];then 
#1.������С����Ӧ����8
	v_length=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep MIN_PASSWORD_LENGTH |awk -F"=" '{print $2}')
   [ -z "$v_length" ] && v_length="0"
	if [ $v_length -ge 8 ];then
           echo "������С���ȴ��ڵ���8���Ϲ�">> $v_logfile
	else
     	   echo "������С���Ȳ���δ����Ϊ8�����Ϲ�">> Conviction.out
	fi

#2.�������ٰ����ַ�����Ӧ����3
	v_upper=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_UPPER_CASE_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_upper" ] && v_upper="0"
	v_lower=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_LOWER_CASE_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_lower" ] && v_lower="0"
	   v_case=$(($v_upper+$v_lower))
	v_digit=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_DIGIT_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_digit" ] && v_digit="0"
	v_special=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_SPECIAL_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_special" ] && v_special="0"	   
	
	if  [ $v_case -ge 1 -a $v_digit -ge 1 -a $v_special -ge 1 ] ;then
           echo "�������ٰ���3���ַ����ͣ��Ϲ�">> $v_logfile
	else
     	   echo "��������3���ַ����ͣ����Ϲ�">> Conviction.out
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
    echo "���Ϲ棬����δ��������ǿ�Ȳ��� " >> $v_logfile
fi
[ -f  Conviction.out ] && rm -f  Conviction.out
