#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthchecklog6;

resulta=0

v_totalnum=0;

rm -f $tmp_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES2.out;
rm -f $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
v_p=`grep "V_ORA_HEA_GATHERHOURS" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=1
fi
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthchecklog6;
tmp_dir=/home/ap/healthchecklog6;

su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_version" > $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES3.out;


su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_dbaschedulerjobs.sql" > $log_dir/scheduler.log;
rm $log_dir/scheduler.log;

v_num=`cat $tmp_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES2.out|grep -v SQL|grep -v NO|awk '{print $1}'|wc -l`;

v_version=`cat $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES3.out|grep 9i|wc -l`;


if [ $v_version -eq 0 ]
then

if [ $v_num -gt 0 ]
then
 for v_hours in `cat $tmp_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES2.out|grep -v SQL|grep -v NO|awk '{print $1}'`;
 do
    if [ $v_hours -gt $v_p ]
    then
    echo $v_hours >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_NUM.out;
    fi
 done
else
#echo "Non-Compliant";
  echo "数据库实例"$sid": 正常 [阀值="$v_p"]hours" >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
fi

if [ -f $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_NUM.out ]
then
    v_size=`cat $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_NUM.out|wc -l`;
    if [ $v_size -gt 2 ]
    then
    #echo "Non-Compliant";
      resulta=`echo \`expr $resulta + 1\``;
      echo "数据库实例"$sid": 不正常" >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
      echo "$v_size 次 GATHER_STATS_JOB 运行时间超过 ["$v_p"]hours" >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
    else
    #echo "Compliant";
      echo "数据库实例"$sid": 正常 [阀值="$v_p"]hours" >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
    fi
else
    #echo "Compliant";
    echo "数据库实例"$sid": 正常 [阀值="$v_p"]hours" >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
fi

else
echo "数据库实例"$sid": 正常" >> $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES.out;
fi;

done
rm -f $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_NUM.out;
rm -f $tmp_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES2.out;
rm -f $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES3.out;

rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
#echo $?
