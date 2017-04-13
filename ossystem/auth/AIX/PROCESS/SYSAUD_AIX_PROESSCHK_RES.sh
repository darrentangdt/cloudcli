#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_PROCESSCHK_RES.sh             #
# 作  者：CCSD_liyu                              #
# 日  期：2012?3月27日                        #
# 功  能：检查sendmail服务                       #
# version：   1.0                                #              
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSAUD_AIX_PROCESSCHK_RES.out"
> $logfile

v_p1="cas_agent platform_agent cimservices pconsole naudio2 naudio: writesrv qdaemon xmdaily rcwpars"
for ss in $v_p1;do
if grep "^$ss" /etc/inittab >/dev/null 2>&1;then
echo "disable $ss service\t\t\t\terror,please to edit /etc/inittab and disable" >> $logfile
else
:
fi
done
if [ -s $logfile ];then
   echo "Non-Compliant"
else
   echo "Compliant"
   echo "ok" >> $logfile
fi

exit 0
