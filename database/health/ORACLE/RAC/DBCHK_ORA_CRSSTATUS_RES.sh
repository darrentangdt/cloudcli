#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
###Edit by ycl 20120730
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;

rm -f $log_dir/DBCHK_ORA_CRSSTATUS_RES.out;

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_version" > $log_dir/DBCHK_ORA_CRSSTATUS_RES3.out;

done

v_num=`cat $log_dir/DBCHK_ORA_CRSSTATUS_RES3.out|grep 9i|wc -l`;

if [ $v_num -gt 0 ]
then

v_cnum=`echo $PATH|grep 'crs/bin'|wc -l`;

if [ $v_cnum -gt 0 ]
then

crs_stat -t|grep ora > $log_dir/DBCHK_ORA_CRSSTATUS_RES2.out;

#add by ycl 20120730  grep -v GSD
v_num=`cat $log_dir/DBCHK_ORA_CRSSTATUS_RES2.out|awk '{print $4}'|grep -v ONLINE|grep -v GSD|wc -l`
rm -f $log_dir/DBCHK_ORA_CRSSTATUS_RES2.out;

if [ $v_num -gt 0 ]
then
echo "Non-Compliant";
echo "不正常 以下的CRS组件状态不是[online]:" > $log_dir/DBCHK_ORA_CRSSTATUS_RES.out;
cat $log_dir/DBCHK_ORA_CRSSTATUS_RES2.out|awk '{print $4}'|grep -v ONLINE >> $log_dir/DBCHK_ORA_CRSSTATUS_RES.out;
else
echo "Compliant";
echo '正常' > $log_dir/DBCHK_ORA_CRSSTATUS_RES.out;
fi

else
echo "Non-Compliant";
echo "找不到crs_stat命令，请将crs的命令加入到root的PATH中" > $log_dir/DBCHK_ORA_CRSSTATUS_RES.out;
fi
else
echo "Compliant";
echo '正常' > $log_dir/DBCHK_ORA_CRSSTATUS_RES.out;
fi

rm -f $log_dir/DBCHK_ORA_CRSSTATUS_RES2.out;
#echo $?
