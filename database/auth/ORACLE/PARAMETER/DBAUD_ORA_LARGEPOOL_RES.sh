#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by YCL 20121122
###AUDIT CHECK
###DBAUD_ORA_LARGEPOOL_RES.sh
###根据应用确定，>100M
#############################################################

#检查临时脚本输出目录是否存在
export LANG=C
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi
#设置oracle 临时输出文件
cd $log_dir/oracle >/dev/null 2>&1
if [ $? -ne 0 ]; then
    mkdir $log_dir/oracle
fi
#log_dir=$log_dir/oracle
#sh_dir=$sh_dir;


#清空历史数据
> $log_dir/DBAUD_ORA_LARGEPOOL_RES.out

#设置标记值
resulta=0
#取阀值
v_p=`grep "V_ORA_AUD_SPOOLSIZE" $sh_dir/ORA_AUD_PARA.txt |awk -F= '{print $2}'|head -1`
if [[ -z $v_p ]]
then
    #默认100M
    v_p=100
fi

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir/oracle;
	if [ -f $log_dir/oracle/DBAUD_ORA_LARGEPOOL_RES2.out ];then
       rm $log_dir/oracle/DBAUD_ORA_LARGEPOOL_RES2.out
    fi
  #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_largesize.sql " > $log_dir/out.log;
    rm $log_dir/out.log
    v_largesize=`cat $log_dir/oracle/DBAUD_ORA_LARGEPOOL_RES2.out|grep -Ev 'SQL|no|^$'|sed 's/ //g'`
	let v_largesize=v_largesize/1024/1024
	#判断是否有大于阀值的记录输出
  if [[ $v_largesize -gt $v_p ]];then
		echo "数据库实例"$sid": 合规 " >>$log_dir/DBAUD_ORA_LARGEPOOL_RES.out
	else 
		resulta=`echo \`expr $resulta + 1\``
    echo "数据库实例"$sid": 不合规" >>$log_dir/DBAUD_ORA_LARGEPOOL_RES.out
    echo "LARGE_POOL_SIZE为["$v_largesize"]M 应该大于阀值["$v_p"]M">>$log_dir/DBAUD_ORA_LARGEPOOL_RES.out
  fi
done


#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
