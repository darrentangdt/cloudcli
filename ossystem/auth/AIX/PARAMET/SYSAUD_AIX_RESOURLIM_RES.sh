#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_RESOURLIM_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月22日                        #
# 功  能：检查系统资源限制情况                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_RESOURLIM_RES.out"
> $v_logfile

ulimit -a | awk '{if ($NF != "unlimited"){print "root user\t"$0"\t\t\tFail"}}' >> $v_logfile
if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "系统存在root用户默认权限未放开的项,建议将root用户默认的limit各项设置为-1" >> $v_logfile
ulimit -a >> $v_logfile
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_RESOURLIM_RES.out
fi

exit 0