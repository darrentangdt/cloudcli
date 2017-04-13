#!/bin/sh
#************************************************#
# �ļ�����SYSAUD_VIOC_AIX_MAXFREE_RES.sh
# ��  �ߣ�iomp_zcw
# ��  ��:2014��2��10��
# ��  �ܣ����maxfree��������
# �����ˣ�
#************************************************#

#�жϸ�̨�����ǲ���VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#�����ʱ�ű����Ŀ¼�Ƿ����
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

v_logfile="SYSAUD_VIOC_AIX_MAXFREE_RES.out"
> $v_logfile

vmo -aF|awk -F= '/maxfree =/{if($2==1088){}else{print "maxfree="$2"\t\t\t\terror"}}' >> $v_logfile

if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "�쳣,ϵͳ����maxfree��ǰֵΪ[$(vmo -aF|awk -F= '/maxfree =/{print $0}')], δ����Ϊ[1088],�����Ϲ�" >> $v_logfile
else
echo "Compliant"
echo "����" >> $v_logfile
fi

exit 0







