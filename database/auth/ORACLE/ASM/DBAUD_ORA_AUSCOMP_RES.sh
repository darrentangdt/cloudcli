#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by chenhd 20091104
###This script is a compliant check script of oracle database
#############################################################
rm -f $log_dir/DBAUD_ORA_AUSCOMP_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $log_dir/DBAUD_ORA_AUSCOMP_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_auscomp" > $log_dir/DBAUD_ORA_AUSCOMP_RES2.out
v_p=`cat $log_dir/DBAUD_ORA_AUSCOMP_RES2.out|grep -i "AUS"|awk -F= '{print $2}'`
v_aus=`echo $v_p|cut -d ";" -f 1`
v_asm=`echo $v_p|cut -d ";" -f 2|cut -c1-6`
v_db=`echo $v_p|cut -d ";" -f 3|cut -c1-6`
echo $sid ":">>$log_dir/DBAUD_ORA_AUSCOMP_RES.out
if [[ $v_aus -eq 4194304 && $v_asm -eq "11.2.0" && $v_db -eq "11.2.0"  ]];then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_AUSCOMP_RES.out
else
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "检查 asm_diskgroup, ALLOCATION_UNIT_SIZE大小为"$v_aus",推荐设置为4M" >>$log_dir/DBAUD_ORA_AUSCOMP_RES.out
echo " COMPATIBILITY为"$v_asm",推荐设置为11.2.0" >>$log_dir/DBAUD_ORA_AUSCOMP_RES.out
echo " DATABASE_COMPATIBILITY为"$v_db",推荐设置为11.2.0" >>$log_dir/DBAUD_ORA_AUSCOMP_RES.out
fi
done
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
