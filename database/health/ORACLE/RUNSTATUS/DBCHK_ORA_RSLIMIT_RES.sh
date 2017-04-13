#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20100126
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthchecklogrslimit;

rm -f $log_dir/DBCHK_ORA_RSLIMIT_RES.out
resulta=0

v_p=`grep "V_ORA_HEA_RSLIMIT" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=70
fi
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $tmp_dir/DBCHK_ORA_RSLIMIT_RES2.out

chown $username /home/ap/healthchecklogrslimit;
tmp_dir=/home/ap/healthchecklogrslimit;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_resourcelimit.sql $v_p" > $log_dir/pga.log;
rm $log_dir/pga.log;

v_count=`cat $tmp_dir/DBCHK_ORA_RSLIMIT_RES2.out |grep -v SQL|grep -v NO|wc -l`;

if [ "$v_count" -eq  0 ];then
#echo "Compliant"
echo "数据库实例"$sid": 正常 [阀值="$v_p"%]">>$log_dir/DBCHK_ORA_RSLIMIT_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_RSLIMIT_RES.out;
echo "以下资源项使用率达到["$v_p"%]:">>$log_dir/DBCHK_ORA_RSLIMIT_RES.out
#cat $log_dir/DBCHK_ORA_RSLIMIT_RES2.out |sed -n '/RESOURCE_NAME/,/Disconnected/p'|grep -v Disconnected>>$log_dir/DBCHK_ORA_RSLIMIT_RES.out

cat $tmp_dir/DBCHK_ORA_RSLIMIT_RES2.out |grep -v SQL|grep -v NO>>$log_dir/DBCHK_ORA_RSLIMIT_RES.out

fi

done

rm -f $tmp_dir/DBCHK_ORA_RSLIMIT_RES2.out;
rm -rf $tmp_dir;
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
