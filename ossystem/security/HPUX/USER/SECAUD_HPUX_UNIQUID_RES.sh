#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_UNIQUID_RES.sh             
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ�����Ƿ�����ظ���UID                  
                                 
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_UNIQUID_RES.out"
> $v_logfile

v_uid1=`logins -d|awk '{print $1}'|uniq`
if [ -z "$v_uid1" ]; then
echo "Compliant"
echo "�Ϲ�" > $v_logfile
else
echo "Non-Compliant"
echo "���Ϲ�" >$v_logfile
logins -d>>$v_logfile
fi
