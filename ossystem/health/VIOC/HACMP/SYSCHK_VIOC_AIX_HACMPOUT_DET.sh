#!/bin/sh
#************************************************#
# �ļ�����SYSCHK_VIOC_AIX_HACMPOUT_DET.sh        #
# ��  �ߣ�CCSD_YOUTONGLI                         #
# ��  �ڣ�2010�� 1��4 ��                         #
# ��  �ܣ����hacmp��־�Ƿ񱨴�                  #
# �����ˣ�                                       #
#************************************************#

export LANG=ZH_CN.UTF-8
log_dir=/home/ap/opscloud/logs 
#�жϸ������ǲ���VIOC
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
	else
		cat ${log_dir}/SYSCHK_VIOC_AIX_HACMPOUT_RES.out
fi
