#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SOMAXCO_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统参数somaxconn设置              #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_SOMAXCO_RES.out"
> $v_logfile
no -aF | awk -F= '/somaxconn/{if ($2 == 2048){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile

if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "系统参数当前值为[$(no -aF | awk -F= '/somaxconn/{print $0}')], 未设置为[2048],属不合规" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0