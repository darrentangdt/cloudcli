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
mkdir -p /home/ap/healthchecklogtbsrate;

rm -f $log_dir/DBCHK_ORA_TBSRATE_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

chown $username /home/ap/healthchecklogtbsrate;
tmp_dir=/home/ap/healthchecklogtbsrate;

v_p=`grep "V_ORA_HEA_TBSRATIO" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=75
fi

rm -f $log_dir/DBCHK_ORA_TBSRATE_RES2.out
rm -f $log_dir/DBCHK_ORA_TBSRATE_RES3.out
rm -f $log_dir/DBCHK_ORA_TBSRATE_RES4.out
#su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_tbsuserate" > $log_dir/DBCHK_ORA_TBSRATE_RES2.out;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_tbsuserate.sql" > $log_dir/tbslogsql.log;
#su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_dbname.sql" > $log_dir/tbslogsql.log;
rm $log_dir/tbslogsql.log;

#v_dbname=`cat $tmp_dir/DBCHK_ORA_DBNAME.out |grep -v 'SQL>'|awk '{print $1}'`

for tb in `cat $tmp_dir/DBCHK_ORA_TBSRATE_RES2.out |grep -v 'SQL>'`
do
v_name=`echo $tb|awk -F= '{print $1}'`
v_pe=`grep -i $sid$v_name $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
v_tsize=`echo $tb|awk -F= '{print $2}'`;


if [ $v_pe ] 
then
if [ $v_tsize -gt $v_pe ]
then
resulta=`echo \`expr $resulta + 1\``;
echo $v_name" 的使用率为"[$v_tsize%]",超过其自定义阈值[$v_pe%]">>$log_dir/DBCHK_ORA_TBSRATE_RES3.out;
else
echo $v_name" 的使用率为"[$v_tsize%]",其自定义阈值[$v_pe%]" >> $log_dir/DBCHK_ORA_TBSRATE_RES4.out;
fi
else
if [ $v_tsize -gt $v_p ]
then
resulta=`echo \`expr $resulta + 1\``;
echo $v_name" 的使用率为"[$v_tsize%]",超过其阈值[$v_p%]">>$log_dir/DBCHK_ORA_TBSRATE_RES3.out;
fi

fi
done

if [ $resulta -eq 0 ] ;then
echo "数据库实例"$sid"：正常 [默认阈值=$v_p%]">$log_dir/DBCHK_ORA_TBSRATE_RES.out;
if [ -f $log_dir/DBCHK_ORA_TBSRATE_RES4.out ];then
cat $log_dir/DBCHK_ORA_TBSRATE_RES4.out >> $log_dir/DBCHK_ORA_TBSRATE_RES.out;
fi
else
echo "数据库实例"$sid"：不正常">>$log_dir/DBCHK_ORA_TBSRATE_RES.out
cat $log_dir/DBCHK_ORA_TBSRATE_RES3.out >> $log_dir/DBCHK_ORA_TBSRATE_RES.out;
fi

done

rm -rf $tmp_dir;
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
