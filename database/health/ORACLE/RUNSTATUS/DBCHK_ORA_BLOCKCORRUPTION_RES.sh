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
mkdir -p /home/ap/healthchecklog3;

resulta=0


rm -f $tmp_dir/DBCHK_ORA_BLOCKCORRUPTION_RES2.out;
rm -f $log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES.out;

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthchecklog3;
tmp_dir=/home/ap/healthchecklog3;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_blockcorruption.sql" > $log_dir/block.log;
rm $log_dir/block.log;

v_num=`cat $tmp_dir/DBCHK_ORA_BLOCKCORRUPTION_RES2.out|grep -v SQL|grep -v NO|wc -l`

if [ $v_num -gt 0 ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo "数据库实例"$sid": 不正常" >> $log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES.out;
echo "存在的坏块如下:" > $log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES.out;
cat $log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES2.out|grep -v SQL|grep -v NO>>$log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES.out;
else
#echo "Compliant";
echo '数据库实例'$sid': 正常' >> $log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES.out;
fi

rm -f $tmp_dir/DBCHK_ORA_BLOCKCORRUPTION_RES2.out;
done

rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
#echo $?
