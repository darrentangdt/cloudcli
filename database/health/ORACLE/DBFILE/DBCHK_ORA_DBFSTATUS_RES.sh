#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by ycl 20130824
###check datafile status
###This script is a health check script of oracle database
#############################################################
rm -f $log_dir/DBAUD_ORA_DBFSTATUS_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $log_dir/DBAUD_ORA_DBFSTATUS_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_dbfilestatus" > $log_dir/DBAUD_ORA_DBFSTATUS_RES2.out

v_count=`cat $log_dir/DBAUD_ORA_DBFSTATUS_RES2.out |grep 'DBF='|wc -l`

if [ "$v_count" -eq 0 ]; then
#echo "Compliant"
resulta=`echo \`expr $resulta + 0\``
echo "数据库实例"$sid":正常">>$log_dir/DBAUD_ORA_DBFSTATUS_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常">>$log_dir/DBAUD_ORA_DBFSTATUS_RES.out;
echo "以下数据文件不正常:">>$log_dir/DBAUD_ORA_DBFSTATUS_RES.out
cat $log_dir/DBAUD_ORA_DBFSTATUS_RES2.out |grep 'DBF=' |awk -F = '{print $2}' >>$log_dir/DBAUD_ORA_DBFSTATUS_RES.out;
fi
done

rm -f $log_dir/DBAUD_ORA_DBFSTATUS_RES2.out;
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
