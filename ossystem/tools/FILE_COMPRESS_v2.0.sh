#!/bin/sh
#################################################
# �ļ�����FILE_COMPRESS.sh                       #
# ��  �ߣ�CCSD_                                 #
# ��  �ڣ�2013�� 7��4��                         #
# ��  ����v2.0                                  #
# ��  �ܣ���ƽ̨Ӧ���ļ�����ű�                #
# �����ˣ�                                      #
#################################################
export LANG=en_US

#���ù��ú�����

source /usr/bin/CloudFun.shl

#��ʼ��ȫ�ֱ���
init

#����ȫ�ֱ���
VERSION="V2.0"                 #version
MODIFIED_TIME="07/13/2013"    #modified time
DEPLOY_UNION="CCSD"
LOG_DIR=/var/tmp/file_compress_$$.log   #log file
FLAG="FALSE"


#����Զ��������
easyopt_add "s:" 'export source_path="$OPTARG"'
easyopt_add "d:" 'export dest_path="$OPTARG"'

#-----------------init parameter
#��ʼ���ű�������
easyopt_parse_opts "$@"

#�жϽű������Ƿ����Ҫ��
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
#�����Ϣ����־�ļ��У�1 WARNING,2 ERROR,3 INFO
 writeLog 3 "`now_str` Begin compress ${source_path} to ${dest}"

 
 # �ж�Ŀ�� ·���Ƿ����
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

