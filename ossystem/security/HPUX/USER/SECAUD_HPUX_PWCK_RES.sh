#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_PWCK_RES.sh                
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ�����û���֤��Ϣ��������               
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi
[ -f  Conviction.out ] && rm -f  Conviction.out

v_logfile="SECAUD_HPUX_PWCK_RES.out"
> $v_logfile

pwck -l >/dev/null 2>&1
if [ $? -eq 0 ]; then
echo "Compliant" 
echo "�Ϲ�">$v_logfile
else
pwck -l 2>Conviction.out
cat /home/ap/opsware/script/tmp/Conviction.out|grep passwd|grep -v  ^[[:space:]]*#|grep -v false$|awk -F":" '{print substr($1,15)}'|uniq>Conviction1.out
if [ -s Conviction1.out ];then 
echo "���Ϲ�,�����û���֤��Ϣ��������" >$v_logfile
cat /home/ap/opsware/script/tmp/Conviction1.out>>$v_logfile
echo "Non-Compliant"
else 
echo "Compliant" 
echo "�Ϲ�">$v_logfile
fi
fi
[ -f  Conviction.out ] && rm -f  Conviction.out
[ -f  Conviction1.out ] && rm -f  Conviction1.out
