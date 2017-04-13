#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
###Write by fusc 20110725
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
resulta=0;

rm -f $log_dir/DBCHK_ORA_PGASIZE_RES.out

v_p=`grep "V_ORA_HEA_PGAUSE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]]
then
    v_p=95
fi
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $log_dir/DBCHK_ORA_PGASIZE_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_pga" > $log_dir/DBCHK_ORA_PGASIZE_RES2.out


v_use=`cat $log_dir/DBCHK_ORA_PGASIZE_RES2.out |grep -Ev 'xxx'|grep pgause|cut -d"=" -f2`


if [ $v_use -gt $v_p ]
then
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不正常" >> $log_dir/DBCHK_ORA_PGASIZE_RES.out;
echo "PGA的使用率超过 ["$v_p"%],其使用率为[" $v_use "%]">> $log_dir/DBCHK_ORA_PGASIZE_RES.out

else
echo '数据库实例'$sid'：正常 [阀值='$v_p'%]' >> $log_dir/DBCHK_ORA_PGASIZE_RES.out;


fi

done

rm -f $log_dir/DBCHK_ORA_PGASIZE_RES2.out;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
