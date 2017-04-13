#!/bin/sh
#************************************************#
# �ļ�����SYSCHK_VIOC_AIX_HACMPSTAT_RES.sh       #
# ��  �ߣ�CCSD_YOUTONGLI                         #
# ��  �ڣ�2010�� 1��4 ��                         #
# ��  �ܣ����HACMP˫���ڵ�״̬                  #
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

v_clstr=`lssrc -g cluster |grep "clstrmgrES"`
if [ ! -z "$v_clstr" ]; then
v_node_num=`/usr/es/sbin/cluster/clstat -o | grep "Node:" |grep "UP" |wc -l`
   if [ $v_node_num -eq 2 ]; then
   echo "Compliant"
   echo "����" > SYSCHK_VIOC_AIX_HACMPSTAT_RES.out
   echo "/usr/es/sbin/cluster/clstat -o ������ʾ����:" >>SYSCHK_VIOC_AIX_HACMPSTAT_RES.out
   /usr/es/sbin/cluster/clstat -o >>SYSCHK_VIOC_AIX_HACMPSTAT_RES.out  2>&1
   else
   echo "Non-Compliant"
   echo "�쳣,�ȼ��HA�Ƿ���������clinfo����Ҳһͬ����,������������ܴ���˫���ڵ�״̬�쳣��" > SYSCHK_VIOC_AIX_HACMPSTAT_RES.out
   echo "/usr/es/sbin/cluster/clstat -o ������ʾ����:" >>SYSCHK_VIOC_AIX_HACMPSTAT_RES.out   
   /usr/es/sbin/cluster/clstat -o >/dev/null >>SYSCHK_VIOC_AIX_HACMPSTAT_RES.out 2>&1
   fi
   else
   echo "Compliant"
   echo "����" > SYSCHK_VIOC_AIX_HACMPSTAT_RES.out
   echo "/usr/es/sbin/cluster/clstat -o ������ʾ����:" >>SYSCHK_VIOC_AIX_HACMPSTAT_RES.out
   /usr/es/sbin/cluster/clstat -o >>SYSCHK_VIOC_AIX_HACMPSTAT_RES.out  2>&1
fi

exit 0;