#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20100126
###This script is a health check script of oracle database
#############################################################

rm -f $log_dir/DBCHK_ORA_VERSION_RES.out

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`
rm -f $log_dir/DBCHK_ORA_VERSION_RES2.out
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @"$sh_dir"/sqloracle_version" > $log_dir/DBCHK_ORA_VERSION_RES2.out


echo "数据库实例"$sid"的版本信息:" >>$log_dir/DBCHK_ORA_VERSION_RES.out

cat $log_dir/DBCHK_ORA_VERSION_RES2.out|sed -n '/BANNER/,/Disconnected/p'|grep -v Disconnected|tail -5>>$log_dir/DBCHK_ORA_VERSION_RES.out

done

rm -f $log_dir/DBCHK_ORA_VERSION_RES2.out;
echo "Compliant";
