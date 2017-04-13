#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20100126
###This script is a health check script of oracle database
###edit by ycl 20120727
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


> $log_dir/DBCHK_ORA_LOGSWITCH_RES.out

#设置标记值
resulta=0
#提取默认阀值
v_p=`grep "V_LOGSWITCH_TIMES" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`
if [[ -z $v_p ]];then
	v_p=20
fi

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir
	if [ -f $log_dir/DBCHK_ORA_LOGSWITCH_RES2.out ];then
      rm $log_dir/DBCHK_ORA_LOGSWITCH_RES2.out
	fi
    #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_log_history.sql $v_p" > $logdir/logswitch.log;
    rm $logdir/logswitch.log;

	v_count=`cat $log_dir/DBCHK_ORA_LOGSWITCH_RES2.out|grep -v SQL|grep -v no|wc -l`

	#判断是否有大于阀值的记录输出
    if [[ $v_count -eq 0 ]];then
		echo "数据库实例"$sid": 正常 [阀值="$v_p"次]">>$log_dir/DBCHK_ORA_LOGSWITCH_RES.out
	    else resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_LOGSWITCH_RES.out
        echo "下列时间段日志切换次数超过阀值[" $v_p "次]" >>$log_dir/DBCHK_ORA_LOGSWITCH_RES.out
        cat $log_dir/DBCHK_ORA_LOGSWITCH_RES2.out|grep -v SQL >> $log_dir/DBCHK_ORA_LOGSWITCH_RES.out
	 fi
done


#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
