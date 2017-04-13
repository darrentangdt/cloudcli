#!/bin/bash
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp

if [ ! -d $log_dir ]
then
	mkdir $log_dir
fi
systemtype=`uname -a |awk '{print $1}'`
v_p=`grep "V_ORA_HEA_INSTANCE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`

if [[ -z $v_p ]];then
v_p=grep
fi

if [ "$systemtype" = "Linux" ];then
ps -ef |grep ora_smon |grep -v grep|grep -v $v_p|awk  '{print $1, substr($NF,10)}'>$log_dir/oracount.list
else
ps -ef |grep ora_smon |grep -v grep|grep -v $v_p|awk  '{print $1, substr($NF,10)}'>$log_dir/oracount.list
fi
