#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_USERSHELL_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 02月01日                        #
# 功  能：检查/etc/passwd中的shell都存在         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


awk -F: '$3>99{print $1 " " $7}' /etc/passwd | while read ss;do
  set $ss
  test "x$2" = x && test "$1" != "guest" && test "$1" != "nobody" && echo "用户$1的shell项为空,属不合规" >> SYSAUD_AIX_USERSHELL_RES1.out
  test "x$2" != x &&  test ! -f $2 && echo "用户$1的shell $2 不存在,属不合规" >> SYSAUD_AIX_USERSHELL_RES1.out
done

if [ -s SYSAUD_AIX_USERSHELL_RES1.out ]; then
echo "Non-Compliant"
mv SYSAUD_AIX_USERSHELL_RES1.out SYSAUD_AIX_USERSHELL_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_USERSHELL_RES.out
fi
rm -f SYSAUD_AIX_USERSHELL_RES1.out >/dev/null 2>&1
