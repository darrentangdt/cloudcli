#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_LIBSECUR_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 02月01日                        #
# 功  能：检查/usr/lib /usr/share/lib权限        #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


for dir in /usr/lib /usr/share/lib ; do
  test -d $dir && find $dir -type f -perm -756 -exec ls -l {} \; | awk '{print $1,$3,"\t",$4,"\t",$9}' >> SYSAUD_AIX_LIBSECUR_RES1.out
done

if [ -s SYSAUD_AIX_LIBSECUR_RES1.out ]; then
echo "Non-Compliant"
echo "以下所列包含权限大于755的文件系统或目录" > SYSAUD_AIX_LIBSECUR_RES.out
cat SYSAUD_AIX_LIBSECUR_RES1.out >> SYSAUD_AIX_LIBSECUR_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_LIBSECUR_RES.out
fi
rm -f SYSAUD_AIX_LIBSECUR_RES1.out
