#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by ycl 20130824
###check TABLES  OF ROW CHAINING/MIGRATION 
###This script is a health check script of oracle database
#############################################################
rm -f $log_dir/DBAUD_ORA_UNDORETENTION_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $log_dir/DBAUD_ORA_UNDORETENTION_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_undoretention" > $log_dir/DBAUD_ORA_UNDORETENTION_RES2.out

v_values=`cat $log_dir/DBAUD_ORA_UNDORETENTION_RES2.out |grep 'UNDORETENTION='|cut -d"=" -f2`
v_max=`echo $v_values|cut -d"," -f1`
v_min=`echo $v_values|cut -d"," -f2`

if [ "$v_max" -gt 150000 ]; then
#echo "Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid":不正常">>$log_dir/DBAUD_ORA_UNDORETENTION_RES.out
echo "max(TUNED_UNDORETENTION)值$v_max,大于150000；需要限制其最大大小">>$log_dir/DBAUD_ORA_UNDORETENTION_RES.out
elif [ "$v_min" -lt 7200 ]; then
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常">>$log_dir/DBAUD_ORA_UNDORETENTION_RES.out;
echo "min(TUNED_UNDORETENTION)值$v_max,小于7200；需要增加UNDO" >>$log_dir/DBAUD_ORA_UNDORETENTION_RES.out
else
echo "数据库实例"$sid":正常">>$log_dir/DBAUD_ORA_UNDORETENTION_RES.out
fi
done

#rm -f $log_dir/DBAUD_ORA_UNDORETENTION_RES2.out;
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
