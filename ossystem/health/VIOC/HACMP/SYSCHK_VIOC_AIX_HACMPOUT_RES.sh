#!/bin/sh
#************************************************#
# �ļ�����SYSCHK_VIOC_AIX_HACMPOUT_RES.sh        #
# ��  �ߣ�CCSD_YOUTONGLI                         #
# ��  �ڣ�2010�� 1��4 ��                         #
# ��  �ܣ����hacmp��־�Ƿ񱨴�                  #
# �����ˣ�                                       #
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


v_p1=`grep "V_AIX_HEA_KEY1" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_HEA_KEY2" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

lssrc -g cluster |grep "clstrmgrES" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
if [ -s SYSCHK_VIOC_AIX_HACMPOUT_RES.out ]; then
if [ -s /tmp/hacmp.out ]
then
tail -20 /tmp/hacmp.out |grep -E "$v_p1|$v_p2" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
elif [ -s /var/hacmp/log/hacmp.out ]
then
tail -20 /var/hacmp/log/hacmp.out |grep -E "$v_p1|$v_p2" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
else
cat /dev/null > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi

if [ -s SYSCHK_VIOC_AIX_HACMPOUT_RES.out ]
then
echo "Non-Compliant"
echo "�쳣,hacmp.out�д�����־" >> SYSCHK_VIOC_AIX_HACMPOUT_RES.out
else
echo "Compliant"
echo "����" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi
else
echo "Compliant"
echo "����" > SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi

exit 0;