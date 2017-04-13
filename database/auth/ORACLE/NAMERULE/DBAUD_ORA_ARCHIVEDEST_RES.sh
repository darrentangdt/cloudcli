#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by YCL 20121122
###AUDIT CHECK
###DBAUD_ORA_ARCHIVEDEST_RES.sh
###根据应用确定，>1.2G
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
> $log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
#设置标记值
resulta=0
#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`
	#更改目录权限
	chown $username $log_dir/oracle;
	if [ -f $log_dir/oracle/DBAUD_ORA_ARCHIVEDEST_RES2.out ];then
       rm $log_dir/oracle/DBAUD_ORA_ARCHIVEDEST_RES2.out
    fi
  #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_archive_check" > $log_dir/oracle/DBAUD_ORA_ARCHIVEDEST_RES2.out;
    
    v_archdest=`cat $log_dir/oracle/DBAUD_ORA_ARCHIVEDEST_RES2.out|grep 'Archive destination'|awk '{print $3}'`
	v_archdest1=`echo $v_archdest |awk -F"/" '{print $NF}'`
	v_archdest2=`cat $log_dir/oracle/DBAUD_ORA_ARCHIVEDEST_RES2.out|grep 'Archive destination'|awk '{print $3}'|sed 's/\/[^\/]*$//g'`
    v_p=${sid}
	#判断数据库版本
	db_v=`su - oracle -c "sqlplus -v"|grep -Ev "NEW|MAIL"|grep -v "^$"|awk '{print $3}'|awk -F. '{print $1}'`
	if [ $db_v = "10" ];then
        if [[ ${v_archdest1} = "orarch_${v_p}" ]];then
	      	echo "数据库实例"$sid"归档路径命名: 合规 " >>$log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
	      else 
	      	resulta=`echo \`expr $resulta + 1\``
          echo "数据库实例"$sid"归档路径命名: 不合规" >>$log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
          echo "当前数据库归档路径为["$v_archdest"]">>$log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
        fi
	elif [ $db_v = "11" ];then
	     if [[ ${v_archdest1} = "+ARCH" ]];then
	      	echo "数据库实例"$sid"归档路径命名: 合规 " >>$log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
	      else 
	      	resulta=`echo \`expr $resulta + 1\``
          echo "数据库实例"$sid"归档路径命名不合规" >>$log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
          echo "当前数据库归档路径为["$v_archdest"]">>$log_dir/DBAUD_ORA_ARCHIVEDEST_RES.out
        fi  
	fi
done
#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi

