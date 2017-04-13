#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20100126
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthchecklogtempsize;
resulta=0;

rm -f $tmp_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES2.out;
rm -f $log_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES.out;

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;
chown $username /home/ap/healthchecklogtempsize;
tmp_dir=/home/ap/healthchecklogtempsize;

v_p=`grep "V_ORA_HEA_SQLTEMPSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=500
fi

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_tempsizeforsql.sql $v_p" > $log_dir/tempsize.log;
rm $log_dir/tempsize.log;

v_num=`cat $tmp_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES2.out|grep -v SQL|grep -v NO|wc -l`

if [ $v_num -gt 0 ]
then

resulta=`echo \`expr $resulta + 1\``;
echo "数据库实例"$sid": 不正常" >> $log_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES.out;
echo "占用临时表空间超过 ["$v_p"m]的sql语句为:" >> $log_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES.out;
cat $tmp_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES2.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES.out;
else
resulta=`echo \`expr $resulta + 0\``;
echo "数据库实例"$sid": 正常 [阀值="$v_p"m]"  >> $log_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES.out;
fi
rm -f $tmp_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES2.out;

done
rm -rf $tmp_dir;

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi

