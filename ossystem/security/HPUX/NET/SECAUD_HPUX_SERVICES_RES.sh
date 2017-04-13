#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_SERVICES_RES.sh            
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ����Ǳ�������Ƿ����                 
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_SERVICES_RES.out"
> $v_logfile

SERVICES="daytime SMTP time rexec rlogin rsh rpc.tooltalk uucp bootps finger"
#1.��������ļ�
for service in $SERVICES;do
	cat /etc/inetd.conf|grep ^$service >/dev/null       
	if [ $? -eq 0 ];then
	echo "���Ϲ棬$service�����������ļ�/etc/inetd.conf��δ��ֹ" >>SECAUD_HPUX_SERVICES_RES1.out
	fi
done

#2.�������״̬
PORTS="13 25 37 540 67 79"
for port in $PORTS;do
	netstat -an|grep -w "\*\.$port"|grep LISTEN >/dev/null       
	if [ $? -eq 0 ];then
	echo "���Ϲ棬$port�˿�������" >>SECAUD_HPUX_SERVICES_RES1.out
	fi
done

if [ -s "SECAUD_HPUX_SERVICES_RES1.out" ];then 
echo  "Non-Compliant"
cat SECAUD_HPUX_SERVICES_RES1.out >>SECAUD_HPUX_SERVICES_RES.out
else
echo "Compliant"
echo "�Ϲ棬daytime��SMTP��time��rexec��rlogin��rsh��rpc.tooltalk��uucp��bootps��finger�ȷ����ѽ���">>SECAUD_HPUX_SERVICES_RES.out
fi

rm -f SECAUD_HPUX_SERVICES_RES1.out
