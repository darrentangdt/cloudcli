#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
###Edite by ycl 20120802
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthchecklogindexblevel;

resulta=0

rm -f $tmp_dir/DBCHK_ORA_INDEXBLEVEL_RES2.out;
rm -f $log_dir/DBCHK_ORA_INDEXBLEVEL_RES.out;

#判断阈值是否定义，
v_p=`grep "V_ORA_HEA_INDEXBLEVEL" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`;
if [[ -z $v_p ]];then
v_p=4
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthchecklogindexblevel;
tmp_dir=/home/ap/healthchecklogindexblevel;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_indexblevel.sql $v_p" > $log_dir/indexlevel.log;
rm $log_dir/indexlevel.log;

v_count=`cat $tmp_dir/DBCHK_ORA_INDEXBLEVEL_RES2.out|grep -v SQL|awk '{print $2}'|grep -v NO|wc -l`

if [ $v_count -gt 0 ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常" >> $log_dir/DBCHK_ORA_INDEXBLEVEL_RES.out;
echo "以下的索引blevel大于["$v_p"]:" >> $log_dir/DBCHK_ORA_INDEXBLEVEL_RES.out;
cat $tmp_dir/DBCHK_ORA_INDEXBLEVEL_RES2.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_INDEXBLEVEL_RES.out;
else
#echo "Compliant";
echo '数据库实例'$sid': 正常 [阀值='$v_p']' >> $log_dir/DBCHK_ORA_INDEXBLEVEL_RES.out;
fi
rm -f $tmp_dir/DBCHK_ORA_INDEXBLEVEL_RES2.out;

done
rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
#echo $?
