#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthcheckloglongsql;

resulta=0


rm -f $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES2.out;
rm -f $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
rm -f $log_dir/DBCHK_ORA_LONGTIMESQL_RES4.out;
v_p=`grep "V_ORA_HEA_SQLSECONDS" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=3600
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthcheckloglongsql;
tmp_dir=/home/ap/healthcheckloglongsql;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_longtimesql.sql $v_p" > $log_dir/logsql.log;
rm $log_dir/logsql.log;

#echo '' > $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES2.out;
if [ -f $log_dir/longtimesql.log ]
then


for sqlid in `cat $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES2.out|grep -v SQL|grep -v NO`
do
v_num=`cat $log_dir/longtimesql.log|grep -w $sqlid|wc -l`;

if [ $v_num -eq 0 ]
then

echo $sqlid >> $log_dir/longtimesql.log;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_getsql.sql $sqlid" > $log_dir/logsqlb.log;
rm $log_dir/logsqlb.log;

resulta=`expr $resulta + 1`;
#echo "数据库"$sid": 不正常" >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
#echo '下面的SQL运行时间超过 ['$v_p'seconds]:' >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
cat $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES3.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES4.out;

fi

rm -f $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES3.out;

done
else

v_snum=`cat $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES2.out|grep -v SQL|grep -v NO|wc -l`

if [ $v_snum -gt 0 ]
then
resulta=`expr $resulta + 1`;
for sqlid in `cat $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES2.out|grep -v SQL|grep -v NO`
do
echo $sqlid >> $log_dir/longtimesql.log;



su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_getsql.sql $sqlid" > $log_dir/logsqlb.log;
rm $log_dir/logsqlb.log;

#echo "数据库"$sid": 不正常" >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
#echo '下面的SQL运行时间超过 ['$v_p'seconds]:' >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
cat $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES3.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES4.out;


rm -f $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES3.out;

done
fi


fi

done
rm -f $tmp_dir/DBCHK_ORA_LONGTIMESQL_RES2.out;
rm -rf $tmp_dir

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
echo '数据库'$sid': 不正常' >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
echo '下面的SQL运行时间超过 ['$v_p'seconds]:' >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
cat $log_dir/DBCHK_ORA_LONGTIMESQL_RES4.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;

else
echo "Compliant";
echo '数据库'$sid': 正常 [阀值='$v_p'seconds]' >> $log_dir/DBCHK_ORA_LONGTIMESQL_RES.out;
fi

rm -f $log_dir/DBCHK_ORA_LONGTIMESQL_RES4.out;

#echo $?
