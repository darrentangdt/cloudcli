#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_LSVGNAME_RES.sh             #
# 作  者：CCSD_liyu                              #
# 日  期：2012年12月12日                         #
# 功  能：检查主机vg命名                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#正确命名:从输出结果中检查VG名称如果是由三位项目缩写+vg+2位数字组成表示合规，例如eaivg01，
lsvg |grep -Ev "rootvg|basevg" |grep -iv "[a-z]\{3\}vg[0-9]\{2\}" |sed '/^$/d' > SYSAUD_AIX_LSVGNAME_RES1.out
if [ -s SYSAUD_AIX_LSVGNAME_RES1.out ]; then
 echo "Non-Compliant"
 echo "本系统中以下vg命名不符合vg命名规范" > SYSAUD_AIX_LSVGNAME_RES.out
 cat SYSAUD_AIX_LSVGNAME_RES1.out >> SYSAUD_AIX_LSVGNAME_RES.out
 else
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_LSVGNAME_RES.out
fi
rm -f SYSAUD_AIX_LSVGNAME_RES1.out >/dev/null 2>&1







