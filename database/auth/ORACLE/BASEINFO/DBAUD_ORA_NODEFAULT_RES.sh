#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-11-26
###This script is a compliant check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/audit_nodefault;

#删除上次执行的结果
rm -f $log_dir/DBAUD_ORA_NODEFAULT_RES.out
rm -f /home/ap/audit_nodefault/DBAUD_ORA_NODEFAULT_RES1.out;

#设置标志位为0
resulta=0

#循环机器上所有的数据库实例
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
#获取用户名
username=$(echo $v_para| awk '{print $1}');
#获取SID
sid=`echo $v_para|awk '{print $2}'`

chown $username /home/ap/audit_nodefault;
tmp_dir=/home/ap/audit_nodefault;

#执行SQL语句
su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_nodefault.sql">$log_dir/abc.log;
rm $log_dir/abc.log;

#把执行后的结果放到v_1中
v_1=`cat $tmp_dir/DBAUD_ORA_NODEFAULT1.out|grep -Ewvi no|grep -Ewvi sql |grep -v ^$|awk '{print $1}'`
v_2=`cat $tmp_dir/DBAUD_ORA_NODEFAULT1.out|grep -Ewvi no|grep -Ewvi sql |grep -v ^$|awk '{print $1}'|wc -l`
#如果SQL执行后有结果则不合规
if [[ $v_2 != 0  ]];then
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例:"$sid" 默认参数不合规，以下值请查看合规文档核对" >> $log_dir/DBAUD_ORA_NODEFAULT_RES.out;
echo $v_1 >> $log_dir/DBAUD_ORA_NODEFAULT_RES.out;
else
echo "数据库实例"$sid ":">>$log_dir/DBAUD_ORA_NODEFAULT_RES.out
echo  "参数合规">>$log_dir/DBAUD_ORA_NODEFAULT_RES.out
fi

done
rm -rf $tmp_dir;

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
