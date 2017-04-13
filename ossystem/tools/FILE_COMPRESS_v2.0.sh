#!/bin/sh
#################################################
# 文件名：FILE_COMPRESS.sh                       #
# 作  者：CCSD_                                 #
# 日  期：2013年 7月4日                         #
# 版  本：v2.0                                  #
# 功  能：云平台应用文件打包脚本                #
# 复核人：                                      #
#################################################
export LANG=en_US

#引用共用函数库

source /usr/bin/CloudFun.shl

#初始化全局变量
init

#定义全局变量
VERSION="V2.0"                 #version
MODIFIED_TIME="07/13/2013"    #modified time
DEPLOY_UNION="CCSD"
LOG_DIR=/var/tmp/file_compress_$$.log   #log file
FLAG="FALSE"


#添加自定义变量。
easyopt_add "s:" 'export source_path="$OPTARG"'
easyopt_add "d:" 'export dest_path="$OPTARG"'

#-----------------init parameter
#初始化脚本变量，
easyopt_parse_opts "$@"

#判断脚本参数是否符合要求
if [ ! -n "$source_path" ] 
then
   echo " Usage : $0 [option] "
   echo " -s source_path,-d dest_path"
   exit 1
fi

if [ ! -n "$dest_path" ]
then
   dest_path=`pwd -P`
   writeLog 1 "dest path not exit,change current path to dest path"
fi
#------------------------main shell-------------------------------#
#输出信息到日志文件中；1 WARNING,2 ERROR,3 INFO
 writeLog 3 "`now_str` Begin compress ${source_path} to ${dest}"

 
 # 判断目标 路径是否存在
if [ ! -d "$dest_path" ]
then
	   mkdir -p $dest_path
       file_compress $source_path $dest_path
	   cd $dest_path
       get_md5 distribute.tgz > PACK_MD5
       writeLog 3 "`now_str` $source_path is  compressed in $dest_path"
else
       dest_path=`pwd`
       file_compress $source_path $dest_path
	   cd $dest_path
       get_md5 distribute.tgz > PACK_MD5
       writeLog 3 "`now_str` $source_path is compressed in $dest_path"
fi


#tar end

