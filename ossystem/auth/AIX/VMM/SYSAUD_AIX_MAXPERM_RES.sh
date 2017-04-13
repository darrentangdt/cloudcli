#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_MAXPERM_RES.sh              #
# 作  者：CCSD_liyu                            #
# 日  期：2012年12月12日                        #
# 功  能：检查maxperm参数设置                    #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_MAXPERM_RES.out"
> $v_logfile
vmo -aF|awk -F= '/maxperm% =/{if($2==90){}else{print "maxperm="$2"\t\t\t\terror"}}' >> $v_logfile

if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "系统参数maxfree当前值为[$(vmo -aF|awk -F= '/maxperm% =/{print $0}')], 未设置为[90],属不合规" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0



