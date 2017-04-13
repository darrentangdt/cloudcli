#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
################################################################
###Write by liuwen 2012.8.13
###This script is a health check script of oracle database
################################################################
#定义脚本目录和日志目录
#sh_dir=$sh_dir;
#log_dir=$log_dir;

#创建临时日志目录
mkdir -p /home/ap/healthcheckmaxserver;

#设置标志位
resulta=0

#删除上次的日志
rm -f $log_dir/DBCHK_ORA_MAXSERVER_RES.out;
rm -f $tmp_dir/DBCHK_ORA_MAXSERVER2.out;

#提取阀值
v_p=`grep "V_ORA_HEA_MAXSERVER" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;

if [[ -z $v_p ]]
then
    v_p=2
fi

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

#设置临时文件的所属组
chown $username /home/ap/healthcheckmaxserver;
tmp_dir=/home/ap/healthcheckmaxserver;

#进行调用SQL语句并把查询结果放到临时日志中
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_maxserver.sql $v_p">$log_dir/abc.log;
rm $log_dir/abc.log;
v_segnum=`cat $tmp_dir/DBCHK_ORA_MAXSERVER2.out|grep -v SQL|grep -v NO`;
v_segnum1=`echo $v_segnum|awk '{print $1}'`;
#echo $v_segnum1
v_segnum2=`echo $v_segnum|awk '{print $2}'`;
#echo $v_segnum2
#echo $v_segnum



if [ $v_segnum1 -gt 0 ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo $sid":不正常:最大并行SERVER数量设置大于服务器[$v_p]倍的CPU个数：当前SERVER个数为:"$v_segnum2 >> $log_dir/DBCHK_ORA_MAXSERVER_RES.out;
#cat $tmp_dir/DBCHK_ORA_MAXSERVER2.out|grep -v SQL>> $log_dir/DBCHK_ORA_MAXSERVER_RES.out;
else
#echo "Compliant";
echo '数据库实例'$sid':正常 [阀值='$v_p']' >> $log_dir/DBCHK_ORA_MAXSERVER_RES.out;
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