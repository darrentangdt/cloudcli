#!/bin/sh
#************************************************#
# �ļ�����SYSCHK_VIOC_AIX_CLUSTERLOG_RES.sh      #
# ��  �ߣ�CCSD_YOUTONGLI                         #
# ��  �ڣ�2010�� 1��4 ��                         #
# ��  �ܣ����clustar.log��־�Ƿ񱨴�            #
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

v_p1=`grep "V_AIX_HEA_HAOUTKEY1" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_HEA_HAOUTKEY2" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

v_date=`date +%b\ %d`
lssrc -g cluster |grep "clstrmgrES" > SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
if [ -s SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out ]; then
if [ -f /usr/es/adm/cluster.log ]
then
tail -100 /usr/es/adm/cluster.log |grep "$v_date" |grep -E "$v_p1|$v_p2" > SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
  if [ -s SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out ]
  then
  echo "Non-Compliant"
  echo "�쳣,cluster.log�д�����־" > SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
  tail -100 /usr/es/adm/cluster.log |grep "$v_date" |grep -E "$v_p1|$v_p2" >> SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
  else
  echo "Compliant"
  echo "����" > SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
  fi
else
echo "Non-Compliant"
echo "�쳣,/usr/es/adm/cluster.log�ļ�������" > SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
fi
else
echo "Compliant"
echo "����" > SYSCHK_VIOC_AIX_CLUSTERLOG_RES.out
fi

exit 0;