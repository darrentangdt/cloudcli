#/bin/bash
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#################################################
# create by chenhd
# this script is for oracle dbfile autoextend check
# 20100120
#################################################

rm -f $log_dir/DBAUD_ORA_TEMPFILEEX_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

rm -f $log_dir/DBAUD_ORA_TEMPFILEEX_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_tempfileautoex" > $log_dir/DBAUD_ORA_TEMPFILEEX_RES2.out

v_count=`cat $log_dir/DBAUD_ORA_TEMPFILEEX_RES2.out|sed -n '/FILE_TYP/,/Disconnected/p'|grep -Ev "Disconnected|FILE_TYP |-|^$"|wc -l`

echo $sid ":">>$log_dir/DBAUD_ORA_TEMPFILEEX_RES.out

if [ "$v_count" -eq 0 ]; then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_TEMPFILEEX_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
cat $log_dir/DBAUD_ORA_TEMPFILEEX_RES2.out|sed -n '/FILE_TYP/,/Disconnected/p'|grep -v "Disconnected">>$log_dir/DBAUD_ORA_TEMPFILEEX_RES.out
fi

done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
