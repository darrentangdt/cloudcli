#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-11-26
###This script is a compliant check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/audit_processes;

#删除上次执行的结果
rm -f $log_dir/DBAUD_ORA_PROCESSES_RES.out
rm -f /home/ap/audit_processes/DBAUD_ORA_PROCESSES_RES1.out;

#设置标志位为0
resulta=0

#循环机器上所有的数据库
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
#获取用户名
username=$(echo $v_para| awk '{print $1}');
#获取SID
sid=`echo $v_para|awk '{print $2}'`

chown $username /home/ap/audit_processes;
tmp_dir=/home/ap/audit_processes;

#执行SQL语句
su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_processes.sql">$log_dir/abc.log;
rm $log_dir/abc.log;

#把执行后的结果放到processes中
processes=`cat $tmp_dir/DBAUD_ORA_PROCESSES1.out|grep -Ewvi no|grep -Ewvi sql |grep -v ^$|awk '{print $1}'`

#如果processes小于500则不合规
if [ $processes -le 500 ];then
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "实例:"$sid" PROCESSES不合规，当前值为:"$processes >> $log_dir/DBAUD_ORA_PROCESSES_RES.out;
echo "合规值为大于等于500" >> $log_dir/DBAUD_ORA_PROCESSES_RES.out;
else

echo "实例:"$sid" PROCESSES合规,当前值为:"$processes >>$log_dir/DBAUD_ORA_PROCESSES_RES.out
fi

done
rm -rf $tmp_dir;

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
