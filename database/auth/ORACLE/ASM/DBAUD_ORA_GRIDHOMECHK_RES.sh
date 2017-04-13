#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by YCL 20121122
###AUDIT CHECK
###DBAUD_ORA_GRIDHOMECHK_RES.sh
###$ORACLE_HOME=/home/db/grid
#############################################################

#检查临时脚本输出目录是否存在
export LANG=C
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi
#log_dir=$log_dir/oracle
#设置oracle 临时输出文件
cd $log_dir/oracle >/dev/null 2>&1
if [ $? -ne 0 ]; then
    mkdir $log_dir/oracle
fi


#清空历史数据
> $log_dir/DBAUD_ORA_GRIDHOMECHK_RES.out

#设置标记值
resulta=0


#更改目录权限
chown grid $log_dir/oracle;
if [ -f $log_dir/oracle/DBAUD_ORA_GRIDHOMECHK_RES2.out ];then
   rm $log_dir/oracle/DBAUD_ORA_GRIDHOMECHK_RES2.out
fi
#判断是否有大于阀值的记录输出
su - grid  <<EOF
env |grep ORACLE_HOME>$log_dir/oracle/DBAUD_ORA_GRIDHOMECHK_RES2.out
EOF
ORA_VERSION=`su - oracle -c "sqlplus -v"|grep -v '^$'|cut -d' ' -f 3|cut -d'.' -f 1-3`

GRID_HOME=`cat $log_dir/oracle/DBAUD_ORA_GRIDHOMECHK_RES2.out|awk -F= '{print $2}'`
#check os 

#HPUX bdf -k,AIX,Linux df -k
[[ `uname` =~ "HPUX" ]] && df=bdf || df=df

HOME_SIZE=`eval  $df -k ${GRID_HOME}|tail -1|awk '{print $2}'`
if [ ${GRID_HOME} != "/home/db/oracle/product/${ORA_VERSION}" ];then
   resulta=`echo \`expr $resulta + 1\``
   echo "数据库不合规" >> $log_dir/DBAUD_ORA_GRIDHOMECHK_RES.out
   echo "grid软件安装路径,不规范" >> $log_dir/DBAUD_ORA_GRIDHOMECHK_RES.out  
fi
if [ ${HOME_SIZE} -lt $((40*1000*1000)) ];then
   resulta=`echo \`expr $resulta + 1\``
   echo "数据库不合规" >> $log_dir/DBAUD_ORA_GRIDHOMECHK_RES.out
   echo "grid软件安装路径为"$((HOME_SIZE/1000/1000))"G,小于推荐值40G" >> $log_dir/DBAUD_ORA_GRIDHOMECHK_RES.out
fi
	

#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
