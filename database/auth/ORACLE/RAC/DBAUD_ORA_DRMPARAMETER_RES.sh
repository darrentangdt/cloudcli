#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by YCL 20120816
###检查RAC隐藏参数_gc_affinity_time，是否设置，
###不设置 DRM 功能可能会引起宕机
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
#sh_dir=/home/ap/opsware/agent/scripts/HEALTH_CHECK/ORACLE;



#清空历史数据
> $log_dir/DBAUD_ORA_DRMPARAMETER_RES.out

#设置标记值
resulta=0

#实例循环检查
db_v=`su - oracle -c "sqlplus -v"|grep -Evi "NEW|mail|^$"|awk '{print $3}'|awk -F. '{print $1}'`
if [ $db_v -eq '11' ];then
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir/oracle;
    rm $log_dir/oracle/DBAUD_ORA_DRMPARAMETER_RES2.out >/dev/null 2>&1
    #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_drmparameter.sql " > $log_dir/out.log;
    rm $log_dir/out.log
    gc_policy_time=`cat $log_dir/oracle/DBAUD_ORA_DRMPARAMETER_RES2.out|grep -Ev 'SQL|no|^$'|grep _gc_policy_time|awk -F"=" '{print $2}'|sed 's/ //g'`
	#判断记录输出
    if [[ $gc_policy_time -ne 0 ]];then
	    resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid": 不合规" >>$log_dir/DBAUD_ORA_DRMPARAMETER_RES.out
        echo "DRM参数为_gc_policy_time="${gc_policy_time}",11g推荐设置为0">>$log_dir/DBAUD_ORA_DRMPARAMETER_RES.out
	else 
	    echo "数据库实例"$sid": 合规" >>$log_dir/DBAUD_ORA_DRMPARAMETER_RES.out
	fi
done
else
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir/oracle;
    rm $log_dir/oracle/DBAUD_ORA_DRMPARAMETER_RES2.out > /dev/null 2>&1
    #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_drmparameter10g.sql " > $log_dir/out.log;
    rm $log_dir/out.log

	v_undo_affinity=`cat $log_dir/oracle/DBAUD_ORA_DRMPARAMETER_RES2.out|grep -Ev 'SQL|no|^$'|grep gc_undo_affinity|awk -F"=" '{print $2}'|sed 's/ //g'`
	v_affinity_time=`cat $log_dir/oracle/DBAUD_ORA_DRMPARAMETER_RES2.out|grep -Ev 'SQL|no|^$'|grep gc_affinity_time|awk -F"=" '{print $2}'|sed 's/ //g'`
	#判断记录输出
    if [[ "$v_undo_affinity" = "FALSE" || $v_affinity_time -eq 0 ]];then
	    resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid": 不正常" >>$log_dir/DBAUD_ORA_DRMPARAMETER_RES.out
        echo "DRM参数为,_gc_undo_affinity="${v_undo_affinity}",_gc_affinity_time="${v_affinity_time}",10g推荐设置这两个参数">>$log_dir/DBAUD_ORA_DRMPARAMETER_RES.out
	else 
	    echo "数据库实例"$sid": 正常" >>$log_dir/DBAUD_ORA_DRMPARAMETER_RES.out
	fi
done
fi
#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
