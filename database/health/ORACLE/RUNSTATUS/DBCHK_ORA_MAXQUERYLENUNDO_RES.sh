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
mkdir -p /home/ap/healthchecklogmaxquerylen;

resulta=0

rm -f $tmp_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES2.out;
rm -f $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES.out;
v_p=`grep "V_ORA_HEA_MAXQUERYLEN" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=5000
fi
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthchecklogmaxquerylen;
tmp_dir=/home/ap/healthchecklogmaxquerylen;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_maxquerylenundo.sql" > $log_dir/maxquerylen.log;
rm $log_dir/maxquerylen.log;

v_maxquerylen=`cat $tmp_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES2.out|grep -v SQL|grep -v NO|head -1|awk '{print $1}'`;
v_spacecnt=`cat $tmp_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES2.out|grep -v SQL|grep -v NO|head -1|awk '{print $2}'`;


echo "数据库实例"$sid":" >> $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES.out;
if [ $v_maxquerylen -gt $v_p ]
then
resulta=`echo \`expr $resulta + 1\``;
echo 'maxquerylen的值超过 ['$v_p']s' >> $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES.out;
else
echo 'maxquerylen的值正常 阀值为['$v_p']s' >> $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES.out;
fi

if [ $v_spacecnt -ne 0 ]
then
resulta=`echo \`expr $resulta + 1\``;
echo "undo 表空间空间不足" >> $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES.out;
else
echo "undo 表空间大小正常" >> $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES.out;
fi

rm -f $tmp_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES2.out;

done
rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
