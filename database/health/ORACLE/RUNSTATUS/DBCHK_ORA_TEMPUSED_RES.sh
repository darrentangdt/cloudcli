#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by ycl 20130824
###check TABLES  OF ROW CHAINING/MIGRATION 
###This script is a health check script of oracle database
#############################################################
rm -f $log_dir/DBAUD_ORA_TEMPUSED_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $log_dir/DBAUD_ORA_TEMPUSED_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_tempused" > $log_dir/DBAUD_ORA_TEMPUSED_RES2.out

v_count=`cat $log_dir/DBAUD_ORA_TEMPUSED_RES2.out |grep 'TEMPS='|cut -d"=" -f2`

if [ "$v_count" -lt 90 ]; then
#echo "Compliant"
resulta=`echo \`expr $resulta + 0\``
echo "数据库实例"$sid":正常">>$log_dir/DBAUD_ORA_TEMPUSED_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常">>$log_dir/DBAUD_ORA_TEMPUSED_RES.out;
echo "TEMP表空间利用率为 ${v_count}%,大于90%,需要扩大TEMP对应表空间">> $log_dir/DBAUD_ORA_TEMPUSED_RES.out
fi
done

#rm -f $log_dir/DBAUD_ORA_TEMPUSED_RES2.out;
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
