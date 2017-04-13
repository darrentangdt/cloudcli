#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 20120807
###检查环境AIXTHREAD 参数是否设置
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
> $log_dir/DBCHK_ORA_AIXTHREAD_RES.out

#设置标记值
resulta=0

#检查系统类型
systemtype=`uname -a |awk '{print $1}'`
if [ "$systemtype" = "AIX" ];then
db_v=`su - oracle -c "sqlplus -v"|grep -v "NEW"|awk '{print $3}'|awk -F. '{print $1}'`
if [ $db_v -eq '11' ];then
echo "Log"
echo "本检查项只对oracle 10g 做检查" >$log_dir/DBCHK_ORA_AIXTHREAD_RES.out
exit 0
fi
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir/oracle;
    rm $log_dir/oracle/DBCHK_ORA_AIXTHREAD_RES2.out
    #su 到oracle用户下执行sql
	su - $username -c "env|grep AIXTHREAD_SCOPE" > $log_dir/oracle/DBCHK_ORA_AIXTHREAD_RES2.out;
    AIXTHREAD_SCOPE=`cat $log_dir/oracle/DBCHK_ORA_AIXTHREAD_RES2.out|tail -1|awk -F"=" '{print $2}'`

  if [ $AIXTHREAD_SCOPE = "S" ]
  then
    echo "数据库实例"$sid": 正常" >>$log_dir/DBCHK_ORA_AIXTHREAD_RES.out
  else
    resulta=`echo \`expr $resulta + 1\``
    echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_AIXTHREAD_RES.out
	echo "建议AIXTHREAD_SCOPE 参数设置为S" >>$log_dir/DBCHK_ORA_AIXTHREAD_RES.out
  fi
done
else
echo "Log"
echo "本检查项只对AIX 系统做检查" >$log_dir/DBCHK_ORA_AIXTHREAD_RES.out
exit 0
fi

#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi