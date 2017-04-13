#!/bin/sh
#*************************************************#
# �ļ�����SECAUD_HPUX_OVERTIME_RES.sh              
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ�����¼��ʱ����                        
#*************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_OVERTIME_RES.out"

> $v_logfile


v_overtime=`cat /etc/profile|grep ^[[:space:]]*TMOUT|awk -F"=" '{print $NF}'`
v_overtime2=`cat /etc/profile|grep ^[[:space:]]*"export"|grep TMOUT|awk -F"=" '{print $NF}'`
if [ EOF$v_overtime = EOF ] && [ EOF$v_overtime2 = EOF ];then
echo "��ǰ�����ļ�/etc/profileδ���ó�ʱ���ԣ����Ϲ�">>SECAUD_HPUX_OVERTIME_RES1.out
elif [ EOF$v_overtime = EOF120 ]  || [ EOF$v_overtime2 = EOF120 ]; then
echo "��ǰ�����ļ�/etc/profile��ʱ����Ϊ120���Ϲ�">>SECAUD_HPUX_OVERTIME_RES.out
else
echo "��ǰ�����ļ�/etc/profile��ʱ����Ϊ $v_overtime $v_overtime2�����Ϲ�">>SECAUD_HPUX_OVERTIME_RES1.out
fi


if [ -s  SECAUD_HPUX_OVERTIME_RES1.out ];then
    echo "Non-Compliant"
    cat SECAUD_HPUX_OVERTIME_RES1.out >> $v_logfile
else
    echo "Compliant"
fi
rm -f SECAUD_HPUX_OVERTIME_RES1.out
