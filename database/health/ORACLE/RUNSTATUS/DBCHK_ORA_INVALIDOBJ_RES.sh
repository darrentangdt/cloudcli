#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20100126
###This script is a health check script of oracle database
###Edit by ycl 20120726
#############################################################
rm -f  $log_dir/DBCHK_ORA_INVALIDOBJ_RES.out
resulta=0

v_invalidjob=`cat $sh_dir/ORA_HEA_PARA.txt|grep V_ORA_HEA_INVALJOB|awk -F'=' '{print $2}'`
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f  $log_dir/DBCHK_ORA_INVALIDOBJ_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_invalidobj" > $log_dir/DBCHK_ORA_INVALIDOBJ_RES2.out


fname=$log_dir/exinvalidobj.log;
if [ -f $fname  ]
then
for na in `cat $log_dir/DBCHK_ORA_INVALIDOBJ_RES2.out |sed -n '/With/,/Disconnected/p'|grep -Ev 'Disconnected|With|-|^$'`
do
v_name1=`cat $log_dir/exinvalidobj.log|grep -w $na|wc -l`
v_name2=`echo $v_invalidjob|grep -w $na|wc -l`
if [[ $v_name1 -eq 0 && $v_name2 -eq 0 ]]
then
echo $na >> $log_dir/DBCHK_ORA_INVALIDOBJ_RES3.out;
echo $na >> $log_dir/exinvalidobj.log;
fi
done
else
touch $log_dir/exinvalidobj.log;
for na in `cat $log_dir/DBCHK_ORA_INVALIDOBJ_RES2.out |sed -n '/With/,/Disconnected/p'|grep -Ev 'Disconnected|With|-|^$'`
do
v_name1=`cat $log_dir/exinvalidobj.log|grep -w $na|wc -l`
v_name2=`echo $v_invalidjob|grep -w $na|wc -l`
if [[ $v_name1 -eq 0 && $v_name2 -eq 0  ]]
then
echo $na >> $log_dir/DBCHK_ORA_INVALIDOBJ_RES3.out;
echo $na >> $log_dir/exinvalidobj.log;
fi
done
fi

if [ -f $log_dir/DBCHK_ORA_INVALIDOBJ_RES3.out ]
then
v_count=`cat $log_dir/DBCHK_ORA_INVALIDOBJ_RES3.out|wc -l`;
if [ "$v_count" -eq  0 ]
then
echo "数据库实例"$sid": 正常">> $log_dir/DBCHK_ORA_INVALIDOBJ_RES.out;
else
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_INVALIDOBJ_RES.out
echo "以下为无效对象:">> $log_dir/DBCHK_ORA_INVALIDOBJ_RES.out
cat $log_dir/DBCHK_ORA_INVALIDOBJ_RES3.out >>$log_dir/DBCHK_ORA_INVALIDOBJ_RES.out
fi

else
echo "数据库实例"$sid": 正常">> $log_dir/DBCHK_ORA_INVALIDOBJ_RES.out;
fi
done

rm -f  $log_dir/DBCHK_ORA_INVALIDOBJ_RES2.out;
rm -f  $log_dir/DBCHK_ORA_INVALIDOBJ_RES3.out;

if [ $resulta -eq 0 ]
then
echo "Compliant"
else
echo "Non-Compliant"
fi
