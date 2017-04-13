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
mkdir -p /home/ap/healthchecklog;
resulta=0
rm -f $tmp_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out;
rm -f $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;
chown $username /home/ap/healthchecklog;
tmp_dir=/home/ap/healthchecklog;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_abcumpdirsize.sql" > $log_dir/abcdump.log;
rm $log_dir/abcdump.log;


su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_version" > $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES3.out;


v_adump=`cat $tmp_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out|grep -v SQL|grep -v NO|grep audit_file_dest|awk '{print $2}'`;
v_cdump=`cat $tmp_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out|grep -v SQL|grep -v NO|grep core_dump_dest|awk '{print $2}'`;
v_bdump=`cat $tmp_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out|grep -v SQL|grep -v NO|grep background_dump_dest|awk '{print $2}'`;
v_udump=`cat $tmp_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out|grep -v SQL|grep -v NO|grep user_dump_dest|awk '{print $2}'`;

rm -f $tmp_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out;
v_pa=`grep "V_ORA_HEA_ADUMPSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
v_pb=`grep "V_ORA_HEA_BDUMPSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
v_pc=`grep "V_ORA_HEA_CDUMPSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
v_pu=`grep "V_ORA_HEA_UDUMPSIZE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;



echo "数据库实例"$sid":" >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
if [ -d $v_cdump'' ]
then

v_csize=`du -sk $v_cdump|awk '{print $1}'`;
v_ccsize=`expr $v_csize \/ 1024`;
if [ $v_csize -gt `expr $v_pc \* 1024` ]
then
resulta=`echo \`expr $resulta + 1\``;
echo $v_cdump 异常：' 超过了 ['$v_pc'm],其目录大小为['$v_ccsize'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
else

echo $v_cdump' 正常 其目录大小为['$v_ccsize'm] [阀值='$v_pc'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi

else
resulta=`echo \`expr $resulta + 1\``
echo cdump' 不存在' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi



if [ -d $v_bdump'' ]
then

v_bsize=`du -sk $v_bdump|awk '{print $1}'`;
v_bbsize=`expr $v_bsize \/ 1024`;
if [ $v_bsize -gt `expr $v_pb \* 1024` ]
then
resulta=`echo \`expr $resulta + 1\``;
echo $v_bdump 异常：' 超过了 ['$v_pb'm],其目录大小为['$v_bbsize'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
else
echo $v_bdump' 正常 其目录大小为['$v_bbsize'm] [阀值='$v_pb'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi

else
resulta=`echo \`expr $resulta + 1\``;
echo bdump' 不存在' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi


if [ -d $v_udump'' ]
then

v_usize=`du -sk $v_udump|awk '{print $1}'`;
v_uusize=`expr $v_usize \/ 1024`;
if [ $v_usize -gt `expr $v_pu \* 1024` ]
then
resulta=`echo \`expr $resulta + 1\``;
echo $v_udump 异常：' 超过了 ['$v_pu'm],其目录大小为['$v_uusize'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
else
echo $v_udump ' 正常 其目录大小为['$v_uusize'm] [阀值='$v_pu'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi

else
resulta=`echo \`expr $resulta + 1\``;
echo udump' 不存在' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi


v_anum=`cat $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES3.out|grep 9i|wc -l`;

if [ $v_anum -eq 0 ]
then

if [ -d $v_adump'' ]
then

v_asize=`du -sk $v_adump|awk '{print $1}'`;
v_aasize=`expr $v_asize \/ 1024`;
if [ $v_asize -gt `expr $v_pa \* 1024` ]
then

resulta=`echo \`expr $resulta + 1\``;
echo $v_adump 异常：' 超过了 ['$v_pa'm],其目录大小为['$v_aasize'm]' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
else
echo $v_adump' 正常 其目录大小为['$v_aasize'm] [阀值='$v_pa'm]'  >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi

else
resulta=`echo \`expr $resulta + 1\``;
echo adump' 不存在' >> $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES.out;
fi

fi
done
rm -rf $tmp_dir;


if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
