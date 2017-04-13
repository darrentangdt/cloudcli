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
mkdir -p /home/ap/healthcheckloghostname;

rm -f $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;


for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

chown $username /home/ap/healthcheckloghostname;
tmp_dir=/home/ap/healthcheckloghostname;



su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_version" > $log_dir/DBCHK_ORA_CRSDLOGERROR_RES3.out;



done


v_num=`cat $log_dir/DBCHK_ORA_CRSDLOGERROR_RES3.out|grep 9i|wc -l`;

if [ $v_num -eq 0 ]
then


v_p=`grep "V_ORA_HEA_CRSDLOGSIZE" $sh_dir/ORA_HEA_PARA.txt|awk -F= '{print $2}'|head -1`;

v_logname=`grep "V_ORA_HEA_CRSDLOGPATH" $sh_dir/ORA_HEA_PARA.txt|awk -F= '{print $2}'`;

v_lognum=`echo $v_logname|grep crsd.log|wc -l`;


if [ $v_lognum -gt 0 ]
then

if [ -f $v_logname ]
then


#first time to check crsd.log
if [ ! -f $log_dir/crsdtotalline.log ]
then


cat $v_logname|grep -wE 'WARNING|fail|errs|ORA-|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' |egrep -v -i " connect failed, rc"> $log_dir/error.log;
#crsd.log including errors
if [ `cat $log_dir/error.log|wc -l` -gt 0 ]
then

if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "Non-Compliant";
echo 'crsd.log 超过 ['$v_p'm] 并包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >$log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;
else
echo "Non-Compliant";
echo 'crsd.log包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >$log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;

fi




#no errors
else


if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "Non-Compliant";
echo 'crsd.log 包含 ['$v_p'm] 但没有 [WARNING][fail][errs]['ORA-'][abort][corrupt][bad][not complete]' > $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;
else
echo "Compliant";
echo '正常 [阀值='$v_p'm]' > $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;
fi



fi

rm -f $log_dir/error.log;

#not first time to check crsd.log

else



v_tonum=`cat $log_dir/crsdtotalline.log|wc -l`;

if [ $v_tonum -gt 0 ]
then
v_linelas=`cat $log_dir/crsdtotalline.log`;
else
v_linelas=0;
fi

v_toline=`cat $v_logname|wc -l`;
v_neline=`expr $v_toline - $v_linelas`;
tail -$v_neline $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' > $log_dir/errorb.log;
#including errors
if [ `cat $log_dir/errorb.log|wc -l` -gt 0 ]
then



if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "Non-Compliant";
echo 'crsd.log 超过 ['$v_p'm] 并包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >$log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
tail -$v_neline $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;
else
echo "Non-Compliant";
echo 'crsd.log中包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete]:' >$log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
tail -$v_neline $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;
fi



#no errors
else

if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "No-Compliant";
echo 'crsd.log 超过 ['$v_p'm] 但没有 [WARNING][fail][errs]['ORA-'][abort][corrupt][bad][not complete]' > $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;

else
echo "Compliant";
echo '正常 [阀值='$v_p'm]' > $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/crsdtotalline.log;

fi

fi

rm -f $log_dir/errorb.log;


fi

else
echo "Non-Compliant";
echo "未找到crsd.log,请在[V_ORA_HEA_CRSDLOGPATH]阀值中定义其路径" >$log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
fi

else
echo "Non-Compliant";
echo "未找到crsd.log,请在[V_ORA_HEA_CRSDLOGPATH]的阀值定义其路径" >$log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
fi

else
echo "Compliant";
echo "正常" > $log_dir/DBCHK_ORA_CRSDLOGERROR_RES.out;
fi


rm -rf $tmp_dir;
rm -f $log_dir/DBCHK_ORA_CRSDLOGERROR_RES2.out;
rm -f $log_dir/DBCHK_ORA_CRSDLOGERROR_RES3.out;

#echo $?;
