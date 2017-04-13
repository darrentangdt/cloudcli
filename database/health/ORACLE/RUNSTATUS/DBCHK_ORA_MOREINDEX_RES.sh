#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
################################################################
###Write by liuwen 2012.8.7
###This script is a health check script of oracle database
################################################################
#定义脚本目录和日志目录
#sh_dir=$sh_dir;
#log_dir=$log_dir;

#创建临时目录
mkdir -p /home/ap/healthcheckmoreindex;

#设置标志位
resulta=0

#清除历史记录
rm -f $log_dir/DBCHK_ORA_MOREINDEX_RES.out;
rm -f $tmp_dir/DBCHK_ORA_MOREINDEX2.out;

#提取阀值
v_p=`grep "V_ORA_HEA_MOREINDEX" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;

if [[ -z $v_p ]]
then
    v_p=5
fi

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

#临时目录的授权
chown $username /home/ap/healthcheckmoreindex;
tmp_dir=/home/ap/healthcheckmoreindex;

#进行调用SQL语句并把查询结果放到临时日志中
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_moreindex.sql $v_p">$log_dir/abc.log;
rm $log_dir/abc.log;
v_segnum=`cat $tmp_dir/DBCHK_ORA_MOREINDEX2.out|grep -v SQL|grep -v NO|awk '{print $1}'|wc -l`;



if [ $v_segnum -gt 0 ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid":不正常">>$log_dir/DBCHK_ORA_MOREINDEX_RES.out;
echo "以下表的索引个数大于["$v_p"]:">>$log_dir/DBCHK_ORA_MOREINDEX_RES.out;
cat $tmp_dir/DBCHK_ORA_MOREINDEX2.out|grep -v SQL>>$log_dir/DBCHK_ORA_MOREINDEX_RES.out;
else
#echo "Compliant";
echo '数据库实例'$sid':正常  [阀值='$v_p'] '>>$log_dir/DBCHK_ORA_MOREINDEX_RES.out;
fi

done
rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi

exit 0