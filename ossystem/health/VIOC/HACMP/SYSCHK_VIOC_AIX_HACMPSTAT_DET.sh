#!/bin/sh
#************************************************#
# �ļ�����SYSCHK_VIOC_AIX_HACMPSTAT_DET.sh       #
# ��  �ߣ�CCSD_YOUTONGLI                         #
# ��  �ڣ�2010�� 1��4 ��                         #
# ��  �ܣ����HACMP˫���ڵ�״̬                  #
# �����ˣ�                                       #
#************************************************#

#�жϸ�̨�����ǲ���VIOC
export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0		
	else
		cat ${log_dir}/SYSCHK_VIOC_AIX_HACMPSTAT_RES.out
fi

