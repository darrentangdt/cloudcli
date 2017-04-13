#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by chenhd 20091104
###This script is a compliant check script of oracle database
#############################################################

rm -f $log_dir/DBAUD_ORA_JOBCHK_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

rm -f $log_dir/DBAUD_ORA_JOBCHK_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_job" > $log_dir/DBAUD_ORA_JOBCHK_RES2.out

v_count=`cat $log_dir/DBAUD_ORA_JOBCHK_RES2.out|sed -n '/JOB/,/Disconnected/p'|grep -v Disconnected|grep -iE 'Y'|wc -l` 
echo $sid ":">>$log_dir/DBAUD_ORA_JOBCHK_RES.out
if [ "$v_count" -eq 0 ];then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_JOBCHK_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
cat $log_dir/DBAUD_ORA_JOBCHK_RES2.out|sed -n '/JOB/,/Disconnected/p'|grep -v Disconnected|grep -iE 'Y'>>$log_dir/DBAUD_ORA_JOBCHK_RES.out
fi
done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
