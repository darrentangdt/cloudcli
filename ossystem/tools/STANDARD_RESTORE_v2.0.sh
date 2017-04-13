#!/bin/sh
#################################################
# 文件名：STANDARD_restore                       #
# 作  者：CCSD_                                 #
# 日  期：2013年 12月20日                         #
# 版  本：v2.0                                  #
# 功  能：云平台应用标准回退                 #
# 复核人：                                      #
#################################################

export LANG=en_US

#引用共用函数库

. /home/ap/opscloud/bin/CloudFun.shl


#定义全局变量
VERSION="V2.0"                 #version
MODIFIED_TIME="07/13/2013"    #modified time
DEPLOY_UNION="CCSD"
LOG_DIR=/tmp/standard_restore_$$.log   #log file
LOCK_FILE=/tmp/standard_restore.lc
FLAG="FALSE"


set -- `getopt s:d:e: $*`

if [ $? != 0 ]
then
    exit 0
fi
while [ $1 != -- ]
do
    case $1 in
        -s)
            source_path="$2"
            shift
            ;;
        -d)
            dest_path="$2"
            shift
            ;;
        -e)
            RSYNC_EXCLUDE_FILE="$2"
            shift
            ;;
        esac
        shift
done



#判断脚本参数是否符合要求
if [ ! -n "$source_path" ] || [ ! -n "$dest_path" ]
then
   echo "Usage $0 [option]"
   echo " -s source path,-d dest_path,-e exclude file list"
   exit 1
fi




#------------------------main shell-------------------------------#
#输出信息到日志文件中；1 WARNING,2 ERROR,3 INFO
writeLog 3 "`now_str` Begin Restore ${source_path}"

if [ ! -d "$source_path" ]
    then
     writeLog 2 "source file path not exit"
     echo source file path not exit
     exit 1
  else
     source=$source_path
  fi

if [ ! -d "$dest_path" ]
then
     writeLog 1 "dest path not exit"
	 cat $LOG_DIR
else
        [ -d ${source%/*} ] && cd ${source%/*}
        rsync_files  ${source##*/} $dest_path  $RSYNC_EXCLUDE_FILE  1>/dev/null 2>>$LOG_DIR
	if [ $? -eq 0 ]
        then
			writeLog 3 "`now_str` restore succeeded"
			#echo "$source_path is success restore in $dest_path "
			cat $LOG_DIR
			exit 0
		else
			writeLog 2 "restore failed"
			#echo "restore failed;Detail message was writed in $LOG_DIR"
			cat $LOG_DIR
			exit 1
        fi
fi

