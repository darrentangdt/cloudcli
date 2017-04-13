#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by fusc 20110415
###This script is a health check script of oracle database
###Edite by ycl 20120802
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p $log_dir/oracle;

resulta=0

> $log_dir/DBAUD_ORA_INDEXBLEVEL_RES.out;

#判断阈值是否定义，
if [[ -z $v_p ]];then
v_p=4
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

	#更改目录权限
	chown $username $log_dir/oracle;
	tmp_dir=$log_dir/oracle
	if [[ -f $log_dir/oracle/DBAUD_ORA_INDEXBLEVEL_RES2.out ]];then
       rm $log_dir/oracle/DBAUD_ORA_INDEXBLEVEL_RES2.out
    fi

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_indexblevel.sql $v_p" > $log_dir/indexlevel.log;
rm $log_dir/indexlevel.log;

v_count=`cat $tmp_dir/DBAUD_ORA_INDEXBLEVEL_RES2.out|grep -v SQL|awk '{print $2}'|grep -v NO|wc -l`

if [ $v_count -gt 0 ]
then
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid": 不合规" >> $log_dir/DBAUD_ORA_INDEXBLEVEL_RES.out;
echo "以下的索引blevel大于["$v_p"]:" >> $log_dir/DBAUD_ORA_INDEXBLEVEL_RES.out;
cat $tmp_dir/DBAUD_ORA_INDEXBLEVEL_RES2.out|grep -v SQL|grep -v NO >> $log_dir/DBAUD_ORA_INDEXBLEVEL_RES.out;
else
#echo "Compliant";
echo '数据库实例'$sid': 合规 [阀值='$v_p']' >> $log_dir/DBAUD_ORA_INDEXBLEVEL_RES.out;
fi

done


if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
