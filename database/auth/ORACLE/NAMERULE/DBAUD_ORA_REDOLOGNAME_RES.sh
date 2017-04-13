#/bin/bash
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#################################################
# create by chenhd
# this script is for oracle sid name check
# 20091228
#################################################

rm -f $log_dir/DBAUD_ORA_REDOLOGNAME_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

rm -f $log_dir/DBAUD_ORA_REDOLOGNAME_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_logfilename" > $log_dir/DBAUD_ORA_REDOLOGNAME_RES2.out

v_count=`cat $log_dir/DBAUD_ORA_REDOLOGNAME_RES2.out|grep REDO0[1-6]_0[1-2]|wc -l`
v_total=`cat $log_dir/DBAUD_ORA_REDOLOGNAME_RES2.out|sed -n '/MEMBER/,/Disconnected/p'|grep -Ev "Disconnected|MEMBER|--|^$"|wc -l`
echo $sid ":">>$log_dir/DBAUD_ORA_REDOLOGNAME_RES.out
if [ "$v_count" -eq "$v_total" ]; then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_REDOLOGNAME_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
cat $log_dir/DBAUD_ORA_REDOLOGNAME_RES2.out|sed -n '/MEMBER/,/Disconnected/p'|grep -v Disconnected >>$log_dir/DBAUD_ORA_REDOLOGNAME_RES.out
fi
done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
