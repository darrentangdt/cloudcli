#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_LSLVNAME_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查主机lv命名                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSAUD_AIX_LSLVNAME_RES.out"
> $logfile

#检查命名是否符合XXXvNNlNNNN命名规范,范例cmpv01l0001
vg_name_on=$(lsvg -o |grep -Ev "rootvg|basevg")
for vg_name in $vg_name_on;do
	lsvg -l $vg_name | sed '1,2d' | awk '{print $1}' | grep -iv "^[a-z]\{3\}v[0-9]\{2\}l[0-9]\{4\}" | grep -iv "^[a-z]\{4\}v[0-9]\{2\}l[0-9]\{4\}" >> $logfile
done

if [ -s "$logfile" ]; then
 echo "Non-Compliant"
 echo "本系统中以上 lv命名 不符合逻辑卷命名规范,ccb要求XXXvNNlNNNN命名规范,范例cmpv01l0001;" >> $logfile
 else
 echo "Compliant"
 echo "合规" >> $logfile
fi

exit 0