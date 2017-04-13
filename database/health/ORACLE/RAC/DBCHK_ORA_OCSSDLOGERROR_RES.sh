#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
###Edit by ycl 20120730
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthchecklogocssd;

username=oracle;



v_p=`grep "V_ORA_HEA_OCSSDLOGSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`;

rm -f  $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES2.out;
rm -f  $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;


for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`


chown $username /home/ap/healthchecklogocssd;
tmp_dir=/home/ap/healthchecklogocssd;



su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_version" > $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES3.out;

done


v_num=`cat $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES3.out|grep 9i|wc -l`;

if [ $v_num -eq 0 ]
then


v_p=`grep "V_ORA_HEA_OCSSDLOGSIZE" $sh_dir/ORA_HEA_PARA.txt|awk -F= '{print $2}'`;

v_logname=`grep "V_ORA_HEA_OCSSDLOGPATH" $sh_dir/ORA_HEA_PARA.txt|awk -F= '{print $2}'`;

v_lognum=`echo $v_logname|grep ocssd.log|wc -l`;


if [ $v_lognum -gt 0 ]
then

if [ -f $v_logname ]
then


#first time to check ocssd.log
if [ ! -f $log_dir/ocssdtotalline.log ]
then

#增加heatbeat|timeout

cat $v_logname|grep -wE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete|heatbeat|timeout'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora'|egrep -i -v "clssgmDeadProc" > $log_dir/ocerror.log;
#ocssd.log including errors
if [ `cat $log_dir/ocerror.log|wc -l` -gt 0 ]
then

if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "Non-Compliant";
echo 'ocssd.log 超过 ['$v_p'm] 并包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete|heatbeat|timeout]:' >$log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;
else
echo "Non-Compliant";
echo 'ocssd.log包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete|heatbeat|timeout]:' >$log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete|heatbeat|timeout'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;

fi




#no errors
else


if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "Non-Compliant";
echo 'ocssd.log 包含 ['$v_p'm] 但没有 [WARNING][fail][errs]['ORA-'][abort][corrupt][bad][not complete][heatbeat][timeout]' > $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;
else
echo "Compliant";
echo '正常 [阀值='$v_p'm]' > $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;
fi



fi

rm -f $log_dir/ocerror.log;

#not first time to check ocssd.log

else



v_tonum=`cat $log_dir/ocssdtotalline.log|wc -l`;

if [ $v_tonum -gt 0 ]
then
v_linelas=`cat $log_dir/ocssdtotalline.log`;
else
v_linelas=0;
fi

v_toline=`cat $v_logname|wc -l`;
v_neline=`expr $v_toline - $v_linelas`;
tail -$v_neline $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete|heatbeat|timeout'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' > $log_dir/ocerrorb.log;
#including errors
if [ `cat $log_dir/ocerrorb.log|wc -l` -gt 0 ]
then



if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "Non-Compliant";
echo 'ocssd.log 超过 ['$v_p'm] 并包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete|heatbeat|timeout]:' >$log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
tail -$v_neline $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;
else
echo "Non-Compliant";
echo 'ocssd.log中包含 [WARNING|fail|errs|'ORA-'|abort|corrupt|bad|not complete|heatbeat|timeout]:' >$log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
tail -$v_neline $v_logname|grep -iwE 'WARNING|fail|errs|ORA|abort|corrupt|bad|not complete|heatbeat|timeout'|grep -v  '[(A-Za-z0-9]\{1,5\}.ora' >> $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;
fi



#no errors
else

if [ `du -sk $v_logname|awk '{print $1}'` -gt `expr $v_p \* 1024` ]
then
echo "No-Compliant";
echo 'ocssd.log 超过 ['$v_p'm] 但没有 [WARNING][fail][errs]['ORA-'][abort][corrupt][bad][not complete][heatbeat][timeout]' > $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;

else
echo "Compliant";
echo '正常 [阀值='$v_p'm]' > $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
cat $v_logname|wc -l > $log_dir/ocssdtotalline.log;

fi

fi

rm -f $log_dir/ocerrorb.log;


fi

else
echo "Non-Compliant";
echo "未找到ocssd.log,在[V_ORA_HEA_OCSSDLOGPATH]阀值中定义的路径不正确" >$log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
fi

else
echo "Non-Compliant";
echo "未找到ocssd.log,请在[V_ORA_HEA_OCSSDLOGPATH]的阀值定义其路径" >$log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
fi

else
echo "Compliant";
echo "正常" > $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES.out;
fi


rm -rf $tmp_dir;
rm -f $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES2.out;
rm -f $log_dir/DBCHK_ORA_OCSSDLOGERROR_RES3.out;

#echo $?;
