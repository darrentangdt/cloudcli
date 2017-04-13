#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_UMASK_RES.sh               
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ�����û�����                           
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_UMASK_RES.out"
> $v_logfile

v_umask=$(cat /etc/profile|grep -v  ^[[:space:]]*#|grep -i UMASK|awk '{print $2}')
[ -z "$v_umask" ] && v_umask="0"
if [ $v_umask -eq 0022 ] || [ $v_umask -eq 022 ] ; then
 echo "�Ϲ棬�����ļ�/etc/profile��umask������Ϊ022">$v_logfile
else
 echo "���Ϲ�,�����ļ�/etc/profile��umaskδ����Ϊ022" >Conviction.out
 cat /etc/profile|grep -v  ^[[:space:]]*#|grep -i UMASK>>Conviction.out
fi

v_umask2=$(umask)
if [ $v_umask2 -eq 0022 ] || [ $v_umask2 -eq 022 ] ; then
 echo "�Ϲ棬��ǰumaskֵΪ022">>$v_logfile
else
 echo "���Ϲ�,��ǰumaskΪ $v_umask2,δ����Ϊ022" >>Conviction.out
fi

if [ -s  Conviction.out ];then   
 echo "Non-Compliant"
 cat Conviction.out >> $v_logfile
else
 echo "Compliant"
 echo "�Ϲ�" >> $v_logfile
fi

[ -f  Conviction.out ] && rm -f  Conviction.out

