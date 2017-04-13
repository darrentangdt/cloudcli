#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
################################################################
###Write by liuwen 2012.8.8
###This script is a health check script of oracle database
################################################################
#定义脚本目录和日志目录
#sh_dir=$sh_dir;
#log_dir=$log_dir;

#创建临时日志目录
mkdir -p /home/ap/healthcheckparallelindex;

#设置标志位
resulta=0

#删除上次的日志
rm -f $log_dir/DBCHK_ORA_PARALLELINDEX_RES.out;
rm -f $tmp_dir/DBCHK_ORA_PARALLELINDEX2.out;


#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;


#设置临时文件的所属组
chown $username /home/ap/healthcheckparallelindex;
tmp_dir=/home/ap/healthcheckparallelindex;

#进行调用SQL语句并把查询结果放到临时日志中
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_parallelindex.sql">$log_dir/abc.log;
rm $log_dir/abc.log;
v_segnum=`cat $tmp_dir/DBCHK_ORA_PARALLELINDEX2.out|grep -v SQL|grep -v NO|awk '{print $1}'|wc -l`;


if [ $v_segnum -gt 0 ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo 数据库$sid"：以下索引并行度大于1">> $log_dir/DBCHK_ORA_PARALLELINDEX_RES.out;
cat $tmp_dir/DBCHK_ORA_PARALLELINDEX2.out|grep -v SQL>> $log_dir/DBCHK_ORA_PARALLELINDEX_RES.out;
else
#echo "Compliant";
echo '数据库实例'$sid':正常' >> $log_dir/DBCHK_ORA_PARALLELINDEX_RES.out;

fi

done
rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi

exit 0;