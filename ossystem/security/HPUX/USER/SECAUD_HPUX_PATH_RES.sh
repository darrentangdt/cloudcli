#!/bin/sh
#************************************************#
# �ļ�����SECAUD_HPUX_PATH_RES.sh                
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��     
# ��  �ܣ����PATH��������                       
#************************************************#

#�����ʱ�ű����Ŀ¼�Ƿ����
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_PATH_RES.out"
> $v_logfile

echo $PATH|grep -E '^\.:|:\.$|^\.\/|:\.\/$|:\.:|:\.\/:' >/dev/null
if [ $? -eq 0 ]; then
echo "PATH������ǰ·������ǰ·��Ϊ$PATH">Conviction.out
fi

echo $PATH|grep -E  "^:"  >/dev/null
if [ $? -eq 0 ]; then
        echo "PATH�����ԣ���ͷ·������ǰ·��Ϊ$PATH,">>Conviction.out
fi

echo $PATH|grep '::'  >/dev/null
if [ $? -eq 0 ]; then
        echo "PATH����::·������ǰ·��Ϊ$PATH">>Conviction.out
fi

echo $PATH|grep -E ':$'  >/dev/null
if [ $? -eq 0 ]; then
        echo "PATH������:��β��·��,��ǰ·��Ϊ$PATH,">>Conviction.out
fi

if [ -s  Conviction.out ];then
 echo "Non-Compliant"
 cat Conviction.out >> $v_logfile
else
 echo "Compliant"
 echo "�Ϲ�" >> $v_logfile
fi
rm -f Conviction.out
