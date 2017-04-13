#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_FULLCORE_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查fullcore选项是否被激活             #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_core=`lsattr -El sys0|grep "fullcore" |awk '{print $2}'`

if [ $v_core = "false" ]
then
echo "Non-Compliant"
echo "sys0属性fullcore未设置为true,属不合规" > SYSAUD_AIX_FULLCORE_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_FULLCORE_RES.out
fi
