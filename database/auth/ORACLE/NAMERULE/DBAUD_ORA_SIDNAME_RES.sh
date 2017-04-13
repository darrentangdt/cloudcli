#/bin/bash
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#################################################
# create by chenhd
# this script is for oracle sid name check
# 20091228
#################################################
rm -f $log_dir/DBAUD_ORA_SIDNAME_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

rm -f $log_dir/DBAUD_ORA_SIDNAME_RES2.out
oracle_sid=`su - $username -c " export ORACLE_SID=$sid;env"|grep ORACLE_SID|awk -F= '{print $2}'`
v_count=`echo "$oracle_sid"|grep [A-Z,a-z][A-Z,a-z][A-Z,a-z][A-Z,a-z][A-Z,a-z][PD,pd,HI,hi,RP,rp,CF,cf][0-9][0,1]|wc -l`

echo $sid ":">>$log_dir/DBAUD_ORA_SIDNAME_RES.out
if [ "$v_count" -eq 1 ]; then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_SIDNAME_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例${sid}命名不规范" >>$log_dir/DBAUD_ORA_SIDNAME_RES.out
echo "SID的命名格式为：XXXXXYY{m}{n}" >>$log_dir/DBAUD_ORA_SIDNAME_RES.out
echo "具体含义参见11g安装规范" >>$log_dir/DBAUD_ORA_SIDNAME_RES.out
fi
done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
