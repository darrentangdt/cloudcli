#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_FSFAST_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统参数fsfastpath设置             #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_FSFAST_RES.out"
> $v_logfile

if [ $(oslevel |cut -c0-1) = "6" ];then
ioo -aF|grep "aio_fsfastpath =" |grep -v "posix_aio_fsfastpath" |awk -F= '{if($2==1){}else{print "aio_fsfastpath="$2"\t\t\terror"}}' >> $v_logfile
elif [ $(oslevel |cut -c0-1) = "5" ];then
aioo -o fsfastpath | awk -F= '{if($2==1){}else{print "aio_fsfastpath="$2"\t\t\terror"}}' >> $v_logfile
fi

if [ -s $v_logfile ]; then
echo "Non-Compliant"
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0