#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_FILERAUTH_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查hacmp脚本的权限                    #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSAUD_AIX_FILERAUTH_RES.out"
> $logfile

v_cluster_stat=$(lssrc -g cluster |awk '/clstrmgrES/{print $0}'|wc -l)
if [ "$v_cluster_stat" -ne 0 ]; then
	if [ -d /hacmp ]; then
		ls -l /hacmp |grep -vE "\-rwxr\-\-r\-\-|total"  >> $logfile
		if [ -s SYSAUD_AIX_FILERAUTH_RES.out ];then
			echo "Non-Compliant"
			echo "以上 /hacmp 目录下的双机启停脚本的文件读写执行属性不是744,属不合规" >> $logfile
		else
			echo "Compliant"
			echo "合规" >> $logfile
		fi
	else
		echo "Non-Compliant"
		echo "hacmp执行脚本没有部署在/hacmp目录下,属不合规" >> $logfile
	fi
else
		echo "Compliant"
		echo "合规" >> $logfile
fi

exit 0