#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
#############################################################
resulta=0

rm -f $log_dir/DBCHK_ORA_BIGSEGMENTS_RES.out;
v_p=`grep "V_ORA_HEA_TABSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=10
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;
chown $username $log_dir
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_bigsegments.sql $v_p" > $log_dir/bigsegments.log;
rm $log_dir/bigsegments.log;

v_segnum=`cat $log_dir/DBCHK_ORA_BIGSEGMENTS_RES2.out|grep -v SQL|grep -v NO|awk '{print $1}'|wc -l`;

if [ $v_segnum -gt 0 ]
then
#echo "Non-Compliant";
resulta=`expr $resulta + 1`;
echo '数据库'$sid': 不正常' >> $log_dir/DBCHK_ORA_BIGSEGMENTS_RES.out;
echo '以下的表超过 ['$v_p'G]：' >> $log_dir/DBCHK_ORA_BIGSEGMENTS_RES.out;
cat $log_dir/DBCHK_ORA_BIGSEGMENTS_RES2.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_BIGSEGMENTS_RES.out;
else
#echo "Compliant";
echo '数据库'$sid': 正常 [阀值='$v_p'G]' >> $log_dir/DBCHK_ORA_BIGSEGMENTS_RES.out;
fi

done

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
#echo $?
