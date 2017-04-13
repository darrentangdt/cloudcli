#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20100126
###This script is a health check script of oracle database
###Edit by YCL 20120807  
###Don't check Compliant or No_Compliant
#############################################################

rm -f $log_dir/DBCHK_ORA_RUNTIME_RES.out

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
rm -f $log_dir/DBCHK_ORA_RUNTIME_RES2.out
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @"$sh_dir"/sqloracle_runtime" > $log_dir/DBCHK_ORA_RUNTIME_RES2.out

v_runtime=`cat $log_dir/DBCHK_ORA_RUNTIME_RES2.out |sed -n '/SYSDATE/,/Disconnected/p'|grep -Ev 'Disconnected|SYSDATE|--|^$'|awk '{print $3}'`


echo "数据库实例"$sid": " >> $log_dir/DBCHK_ORA_RUNTIME_RES.out;
echo "持续运行时间为["$v_runtime"天]">>$log_dir/DBCHK_ORA_RUNTIME_RES.out
done

rm -f $log_dir/DBCHK_ORA_RUNTIME_RES2.out;

echo "Log"