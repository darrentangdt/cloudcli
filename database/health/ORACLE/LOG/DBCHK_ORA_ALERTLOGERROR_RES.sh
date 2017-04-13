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
mkdir -p /home/ap/healthchecklog1;

resulta=0

rm -f $tmp_dir/DBCHK_ORA_ALERTLOGERROR_RES2.out;
rm -f $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
v_p=`grep "V_ORA_HEA_ALERTLOGSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;

if [[ -z $v_p ]];then
v_p=1024
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthchecklog1;
tmp_dir=/home/ap/healthchecklog1;

su - $username -c "export ORACLES_DI=$sid;sh $sh_dir/sqloracle_alertlogerror.sql" > $log_dir/alert.log;
rm $log_dir/alert.log;

v_name=`cat $tmp_dir/DBCHK_ORA_ALERTLOGERROR_RES2.out|grep -v SQL|grep -v NO`;
rm -f $tmp_dir/DBCHK_ORA_ALERTLOGERROR_RES2.out;


if [ ! -f $log_dir/$sid''altotalline.log ]
then
cat $v_name|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' > $log_dir/alerror.log;
#crsd.log including errors
if [ `cat $log_dir/alerror.log|wc -l` -gt 0 ]
then

if [ `du -sk $v_name|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo '数据库实例'$sid': 不正常' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
echo '警告日志超过 ['$v_p'm] 并包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >>$log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
else
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo '数据库实例'$sid': 不正常' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
echo '警告日志包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >>$log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
fi


#no errors
else


if [ `du -sk $v_name|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo '数据库实例'$sid': 不正常' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
echo '警告日志超过 ['$v_p'm] 但不包含 [WARNING][fail][errs]['ORA-'][abort][corrupt][bad][not complete]' >>$log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
else
#echo "Compliant";
echo '数据库实例'$sid':正常 [阀值='$v_p'm]' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
fi


fi
rm -f $log_dir/alerror.log;

#not first time to check crsd.log
else

v_linelas=`cat $log_dir/$sid''altotalline.log`;
v_toline=`cat $v_name|wc -l`;
v_neline=`expr $v_toline - $v_linelas`;
tail -$v_neline $v_name|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' > $log_dir/alerrorb.log;
#including errors
if [ `cat $log_dir/alerrorb.log|wc -l` -gt 0 ]
then


if [ `du -sk $v_name|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo '数据库实例'$sid': 不正常' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
echo '警告日志超过 ['$v_p'm] 并包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >>$log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
tail -$v_neline $v_name|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
else

#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo '数据库实例'$sid': 不正常' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
echo '警告日志包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >>$log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
tail -$v_neline $v_name|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
fi



#no errors
else

if [ `du -sk $v_name|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``;
echo '数据库实例'$sid': 不正常' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
echo '警告日志超过 ['$v_p'm] 但没有 [WARNING][fail][errs]['ORA-'][abort][corrupt][bad][not complete]' >>$log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
else
#echo "Compliant";
echo '数据库实例'$sid':正常 [阀值='$v_p'm]' >> $log_dir/DBCHK_ORA_ALERTLOGERROR_RES.out;
cat $v_name|wc -l > $log_dir/$sid''altotalline.log;
fi


fi

rm -f $log_dir/alerrorb.log;


fi

done
rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi


#echo $?
