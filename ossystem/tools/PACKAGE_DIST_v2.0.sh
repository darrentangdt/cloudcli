#!/bin/sh
#################################################
# 文件名：PACKAGE_DIST.sh                       #
# 作  者：CCSD_YCL                              #
# 日  期：2013年 8月9日                         #
# 版  本：v1.1                                  #
# 功  能：云平台应用分发脚本                    #
# 复核人：                                      #
#################################################
#2013/8/7 add clear_files
#2013/8/9 add MY_GFLAG variable,
#2013/8/15 add "grep -v "^#"
#2013/8/25 配置权限，文件夹配置755，文件配置定义的权限
#2013/9/14 add -x $user 传递目标用户
#2013/12/13 去除空格和制表符  sed 's/[[:space:]]*//g'
#2013/12/17 在中转目录中创建一个分发临时路径，把压缩包解压缩到这里；分发之前先删除这个路径；DISTRIBUTE_DIR
export LANG=en_US

#引用共用函数库
. /home/ap/opscloud/bin/CloudFun.shl

#初始化全局参数

#init

#定义全局变量
VERSION="2.0"                 #version
MODIFIED_TIME="20131120"    #modified time
DEPLOY_UNION="CLOUD"

#公共变量
MY_GFLAG="TRUE"   #全局状态标志位
WHO=`whoami`
IS_MD5=Y     #是否作md5校验
MD5_SUM=0    #md5码校验是否成功
DIST_FLAG=0  #文件分发是否成功
UNC_FLAG=0   #解压缩是否成功
ERR_STAT_CODE=1 #错误代码标志位
OK_STAT_CODE=0   #成功代码标志位
WORD_LIST="USER|GROUP|ALL_AUT|^#|:"

#918
set -- `getopt p:x:c: $*`

if [ $? != 0 ]
then
	exit 0
fi
while [ $1 != -- ]
do
	case $1 in
		-p)
			package="$2"
			shift
			;;
		-x)
			user="$2"
			shift
			;;
		-c)
			IS_MD5="$2"
			shift
			;;
		esac
		shift
done



#去除md5文件的输入，md5文件会和包放在一起，并且位包名_MD5.txt:CCSD1_AP_WEBLOGIC_20130813_V1.0_MD5.txt
#形式为 CCSD1_AP_WEBLOGIC_20130813_V1.0.tgz:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#       CCSD1_AP_WEBLOGIC_20130813_V1.0.cfg:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#easyopt_add "f:" 'export md5file="$OPTARG"'


#初始化脚本变量，
#easyopt_parse_opts "$@"

#添加日志路径变量 2013/09/14
[ X$user = X ] || WHO=$user
TMP_DIR=/home/ap/${WHO}/app_temp
HOME_DIR=$HOME
LOG_DIR=${TMP_DIR}/"DISTRIBUTE_$$.log";
LOCK_FILE=${TMP_DIR}/distribute.lc


#判断脚本参数是否符合要求
if [ ! -n "$package" ] 
then
   echo "Usage $0  [option]"
   echo "-p package_name"
   exit $ERR_STAT_CODE
fi


#取包名,md5文件名
package=${package##*/}
md5file=${package%.tgz}_MD5.txt
config=${package%.tgz}.cfg
#---------------------------start------------------#
writeLog 3 "`now_str` STARTING ....... " ;

if  [ ! -d $TMP_DIR ] 
then
	echo "中转路径不存在" ;
	exit $ERR_STAT_CODE;
else
	#登陆中转路径目录
	#判断tgz包是否存在
	cd  ${TMP_DIR}
fi

if [ ! -f $package ]
then
	writeLog 2  "$package is not exist in $TMP_DIR"
	echo "分发包 $package 在中转目录 $TMP_DIR 中不存在"
	exit $ERR_STAT_CODE
fi
#判断md5码文件是否存在
if [ ! -f $md5file ]
then
	writeLog 2  "$md5file is not exist in $TMP_DIR"
	echo "MD5码文件 $md5file 在中转目录 $TMP_DIR 中不存在"
	exit $ERR_STAT_CODE
fi
#配置文件是否存在
if [ ! -f $config ]
then
	writeLog 2  "$config is not exist in $TMP_DIR"
	echo "分发配置 $config 在中转目录 $TMP_DIR 中不存在"
	exit $ERR_STAT_CODE
else
#验证目标路径是否存在
	cat $config|grep -v "^#"|grep ":"|sed -e 's/#.*//g' -e 's/[[:space:]]*//g' |cut -d":" -f2 |while read line
	do
		if [ ! -d $line ]
		then
			writeLog 2  "目标路径 $line 不存在"
			echo "目标路径 $line 不存在"
			exit $ERR_STAT_CODE
		fi
	done
fi
[ $? -eq 1 ] && MY_GFLAG="FALSE"

if [ "$MY_GFLAG" = "TRUE" ]
then
#检查是否有其它分发程序运行，锁机制
 if [ -e $LOCK_FILE ]; then
       # Exit if the process that created the lock is still running
       LOCK_PID=`cat $LOCK_FILE`
       if [ -n "$LOCK_PID" ]; then
	   FOUND_PROCESS=`ps -p $LOCK_PID -o comm=`
	   # TODO: process should also be a backup process.
	   if [ -n "$FOUND_PROCESS" ]; then
	       writeLog 2 "Distribute didn't run because another Distribute ($LOCK_PID) is still running"
	       exit $ERR_STAT_CODE
	   else
	       echo $$ > $LOCK_FILE
	   fi
       else
	   echo $$ > $LOCK_FILE
       fi
   else
       echo $$ > $LOCK_FILE
 fi
fi
#检查tgz包的 MD5

writeLog 3 "`now_str` Begin CHECK tgz,cfg MD5 ....... " ;
P_MD5_NEW=`get_md5 ${package}|awk '{print $1}'`
P_MD5_OLD=`cat ${md5file}|grep ${package}|sed 's/[[:space:]]*//g'|cut -d":" -f2`
C_MD5_NEW=`get_md5 ${config}|awk '{print $1}'`
C_MD5_OLD=`cat ${md5file}|grep ${config}|sed 's/[[:space:]]*//g'|cut -d":" -f2`

  if [ "$P_MD5_NEW" != "$P_MD5_OLD" ]; then
		[ -f ${LOCK_FILE} ] && rm ${LOCK_FILE}
		writeLog 2  "${package} MD5 值不匹配"
		echo "${package} Md5sum is not match "
		exit $ERR_STAT_CODE
  fi
  if [ "$C_MD5_NEW" != "$C_MD5_OLD" ];then
		[ -f ${LOCK_FILE} ] && rm ${LOCK_FILE}
		writeLog 2  "${config} MD5 值不匹配"
		echo "${config} Md5sum is not match "
		exit $ERR_STAT_CODE
  fi
  
  writeLog 3 "`now_str` End CHECK tgz,cfg MD5 ....... " ;
  writeLog 3 "`now_str` Begin uncompressing ....."

#分发之前清理操作
[ -d DISTRIBUTE_DIR ] && rm -rf  DISTRIBUTE_DIR

mkdir DISTRIBUTE_DIR
cp $md5file DISTRIBUTE_DIR
cp $config DISTRIBUTE_DIR
cp $package DISTRIBUTE_DIR
cd DISTRIBUTE_DIR 
TMP_DIR=${TMP_DIR}/DISTRIBUTE_DIR


# 文件解压缩
if [ "$MY_GFLAG" = "TRUE" ]
then
#调用解压缩函数
	uncompress $package  >/dev/null
	if [ $UNC_FLAG -ne 0 ]
	then
		writeLog 2 "`now_str` uncompress failed"
		echo "uncompress $package failed "
		MY_GFLAG="FLASE"
	fi
else
	writeLog 1 "`now_str` skip uncompress"
fi

writeLog 3 "`now_str` End uncompressing ....."
#解压缩完毕
   
   
#根据配置文件，设置中转路径文件权限
#USER=weblogic
#GROUP=weblogic
#ALL_AUTH=644
##################
#agent/scripts/check_modul.sh=755   #用"="配置特殊权限
###################
#agent/scripts:/home/ap/weblogic/agent

writeLog 3 "`now_str` Begin chmod,chown ....."
owner=`cat  $config |grep -v "^#"|sed -e 's/#.*//g' -e 's/[[:space:]]*//g'|grep "USER"|cut -d"=" -f2`
group=`cat  $config |grep -v "^#"|sed -e 's/#.*//g' -e 's/[[:space:]]*//g'|grep "GROUP"|cut -d"=" -f2`
auth=`cat  $config |grep -v "^#"|sed -e 's/#.*//g' -e 's/[[:space:]]*//g' |grep "ALL_AUTH"|cut -d"=" -f2`
#判断owner，group 是否存在
if [ X"$owner" != "X" ] && [ `grep $owner /etc/passwd|wc -l` -eq 0 ]
then
	writeLog 2 "`now_str` .CFG file define OWNER parameter is not exist in system!!!"
	echo ".CFG file define OWNER [$owner] parameter is not exist in system!!!"
	MY_GFLAG="FALSE"	
fi
if [ X"$group" != "X" ] && [ `grep $group /etc/group|wc -l` -eq 0 ]
then
	writeLog 2 "`now_str` .CFG file define GROUP [$group] parameter is not exist in system!!!"
	echo ".CFG file define GROUP parameter is not exist in system!!!"
	MY_GFLAG="FALSE"
fi

#配置默认权限，文件夹配置755，文件配置配置文件中定义的值
if [ X"$owner" != "X" ] && [ $MY_GFLAG = "TRUE" ]
then
 cat $config|grep -v "^#"|grep ":"|cut -d":" -f1|sed -e 's/#.*//g' -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g'|while read line
 do
 	if [  -d "$line" -o  -f "$line" ]
 	then
 		if [ -d "$line" ]
 		then
 	        	find "$line" -type d ! -perm 0755  -exec chmod 755 {} \;
 	        	[ X"$auth" != X ] && find "$line" -type f ! -perm $auth  -exec chmod $auth {} \;
 		fi
 		if [ -f "$line" ]
 		then
 	        [ X"$auth" != X ] && find "$line" -type f ! -perm $auth  -exec chmod $auth {} \;
 	    fi
 		chown -R ${owner}:${group} $line 
 		if [ $? -gt 0 ]
 		then
 			writeLog 2 "`now_str` chown failed"
 			echo "chown ${owner},${group}  to $line failed"
 			exit 1
 		fi
     else
 		writeLog 2 "`now_str` SourcetPath file: $line dosen't exist!"
 		echo "SourcetPath file: $line dosen't exist!"
 		exit 1
 	fi	
 done
else
	 writeLog 1 "`now_str` skip chmod,chown  ... "
fi

[ $? -eq 1 ] && MY_GFLAG="FALSE"
 
#特定权限设置
#
if [ X"${auth}" != "X" ] && [ $MY_GFLAG = "TRUE" ]
then
 cat $config|grep -Ev "$WORD_LIST"|grep "=" |sed -e 's/#.*//g' -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g'|while read line
 do
    path=`echo $line|cut -d"=" -f1`
 	auth=`echo $line|cut -d"=" -f2`
 	if [  -d ${path} -o  -f ${path} ]
 	then
 	    if [ -d ${path} ]
 		then
 	        find $path -type d ! -perm 0755  -exec chmod 755 {} \;
 	        find $path -type f ! -perm $auth  -exec chmod $auth {} \;
 		fi
 		if [ -f $path ]
 		then
 	        find $path -type f ! -perm $auth  -exec chmod $auth {} \;
 	    fi
     else
 		writeLog 2 "SourcetPath file: $path dosen't exist!"
 		echo "SourcetPath file: $path dosen't exist!"
         exit 1
 	fi	
 done
fi
[ $? -eq 1 ] && MY_GFLAG="FALSE"

writeLog 3 "`now_str` End chmod,chown ....."
writeLog 3 "`now_str` Begin distribute files ....."
#分发文件
if [ $MY_GFLAG = "TRUE" ]
then
  cat  $config|grep -v "^#"|grep ":" |sed -e 's/#.*//g' -e 's/^[[:space:]]*//g' -e 's/[[:space:]]*$//g' |while read line 
  do 
    parameter=`echo $line |sed 's/:/ /g'`
    cp_files $parameter
	#检查分发状态
	if [ $DIST_FLAG -ne 0 ]
	then
	   writeLog 2 "`now_str` file distribute failed"
	echo "`now_str` file distribute failed"
	   exit 1
	fi
  done
else
	writeLog 3 "`now_str` skip distribute files ....."
fi
[ $? -eq 1 ] && MY_GFLAG="FALSE"

writeLog 3 "`now_str` End distribute files ....."
writeLog 3 "`now_str` Begin distribute files check md5   ....."

#检查md5 
if [ $MY_GFLAG = "TRUE" ]
then
	if [ $IS_MD5 = "Y" ]
	then
		cat  $config|grep -v "^#"|grep ":" |sed -e 's/#.*//g' -e 's/[[:space:]]*//g' |while read line 
		do 
			parameter=`echo $line |sed 's/:/ /g'`
			check_md5 $parameter
			#判断md5 检查是否成功
			if [ $MD5_SUM -ne 0 ]
			then
				[ -f ${LOCK_FILE} ] && rm ${LOCK_FILE}	
				writeLog 2 "`now_str` md5 check failed"
				echo "`now_str` md5 check failed"
				exit 1
			fi
		done
	else
		writeLog 3 "`now_str` Pass md5 check ....."
	fi
else
	writeLog 3 "`now_str` skip md5 check ....."
fi
 
[ $? -eq 1 ] && MY_GFLAG="FALSE" 
writeLog 3 "`now_str` End md5 check ....."
 
 # 整体输出状态
if [ "$MY_GFLAG" = "TRUE" ]
then
	writeLog 3 "`now_str` Distribute file successful!" ;
	echo "Distribute file successful"
else
	writeLog 2 "`now_str` Distribute file failed,check logfile : $LOG_DIR  ;"
	echo "Distribute file failed,check logfile : $LOG_DIR "
	exit 1
fi
#清理解压源文件

writeLog 3 "`now_str` Begin clear source files ....."
cd ..
[ -d DISTRIBUTE_DIR ] && rm -rf DISTRIBUTE_DIR
writeLog 3 "`now_str` End clear distribute files ....."
if [ "$MY_GFLAG" = "TRUE" ]
then
	[ -f ${LOCK_FILE} ] && rm ${LOCK_FILE}
	exit 0
else
	[ -f ${LOCK_FILE} ] && rm ${LOCK_FILE}
	exit 1
fi

