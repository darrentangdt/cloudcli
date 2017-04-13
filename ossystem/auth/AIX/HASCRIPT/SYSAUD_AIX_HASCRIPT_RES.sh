#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_HASCRIPT_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查hacmp脚本目录和命名                #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSAUD_AIX_HASCRIPT_RES.out"
> $logfile

v_cl_stat=$(lssrc -g cluster | awk '/clstrmgrES/{print "ha_runing..."}'|wc -l)
v_p1=`grep "V_AIX_AUD_HADIR" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="/hacmp"
if [ "$v_cl_stat" -ne 0 ]; then
	if [ -d $v_p1 ]; then
  	ls -l $v_p1 | grep -v "[A-Za-z]\{5\}app[1-9]start.sh" | grep -v "[A-Za-z]\{5\}app[1-9]stop.sh" >> $logfile
 		 if [ -s "$logfile" ]; then
 	 			echo "Non-Compliant"
  			echo ""$v_p1"目录存在不符合双机启停脚本命名规范(xxx+yy+zzz+1位数字+start.sh或xxx+yy+zzz+1位数字+stop.sh 如ocrdbapp1start.sh)的脚本" >> $logfile
 		 else
 		 		echo "Compliant"
 		 		echo "合规" >> $logfile
		fi
  else
 	 echo "Non-Compliant"
 	 echo "双机启停脚本没有部署在"$v_p1"目录下" >> $logfile
	fi
else
  echo "Compliant"
  echo "合规" >> $logfile
fi

exit 0