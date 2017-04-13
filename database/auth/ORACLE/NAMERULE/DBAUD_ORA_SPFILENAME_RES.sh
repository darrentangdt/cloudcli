#/bin/bash
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#################################################
# create by chenhd
# this script is for oracle spfile name check
# 20091228
#################################################
rm  -f  $log_dir/DBAUD_ORA_SPFILENAME_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

rm  -f  $log_dir/DBAUD_ORA_SPFILENAME_RES2.out
v_dbname=`su - $username -c " export ORACLE_SID=$sid;env" |grep ORACLE_SID|awk -F= '{print $2}'` 
v_spfilename=`echo spfile${v_dbname}.ora`

su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_spfilename" > $log_dir/DBAUD_ORA_SPFILENAME_RES2.out

v_count=`cat $log_dir/DBAUD_ORA_SPFILENAME_RES2.out|grep 'spfile'|wc -l`
echo $sid ":">>$log_dir/DBAUD_ORA_SPFILENAME_RES.out
if [ "$v_count" -ge 1 ]; then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_SPFILENAME_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
cat $log_dir/DBAUD_ORA_SPFILENAME_RES2.out|sed -n '/NAME/,/Disconnected/p'|grep -v Disconnected >>$log_dir/DBAUD_ORA_SPFILENAME_RES.out
fi
done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
