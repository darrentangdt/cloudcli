#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by chenhd 20091104
###This script is a compliant check script of oracle database
#############################################################
rm -f $log_dir/DBAUD_ORA_VERCOMP_RES.out
resulta=0
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

rm -f $log_dir/DBAUD_ORA_VERCOMP_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_version_compare" > $log_dir/DBAUD_ORA_VERCOMP_RES2.out
v_p1=`grep "V_ORA_AUD_DBVER" $sh_dir/ORA_AUD_PARA.txt |awk -F= '{print $2}'`
if [[ `echo $SHELL|awk -F/ '{print $NF}'` = 'ksh' ]];then
set -A a $(echo $v_p1 | tr ';' ' ' | tr -s ' ')
else
a=($(echo $v_p1 | tr ';' ' ' | tr -s ' '))
fi
length=${#a[@]}
sum=0
i=0
while(( $i<$length ))
 do
  m=`grep ${a[$i]} $log_dir/DBAUD_ORA_VERCOMP_RES2.out |wc -l`
     if [ $m -gt 0 ];then
        let sum+=1
     fi
let i+=1
 done


v_version=`tail -10 $log_dir/DBAUD_ORA_VERCOMP_RES2.out | grep "$v_p1" | wc -l`

echo $sid ":">>$log_dir/DBAUD_ORA_VERCOMP_RES.out

if [ $sum -gt 0 ];then
#echo "Compliant"
echo  "合规">>$log_dir/DBAUD_ORA_VERCOMP_RES.out
else
resulta=`echo \`expr $resulta + 1\``
#echo "Non-Compliant"
cat $log_dir/DBAUD_ORA_VERCOMP_RES2.out|grep -i product|sed -n 4p>>$log_dir/DBAUD_ORA_VERCOMP_RES.out
fi

done

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi