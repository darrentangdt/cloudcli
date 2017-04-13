#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SOFTPATH_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查部署软件路径名是否正确             #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


awk -F: '($1 == "oracle") {print $0}' /etc/passwd > oracle_temp
awk -F: '($1 == "informix") {print $0}' /etc/passwd > informix_temp
awk -F: '($1 == "weblogic") {print $0}' /etc/passwd > weblogic_temp
awk -F: '($1 == "tuxedo") {print $0}' /etc/passwd > tuxedo_temp
awk -F: '($1 == "db2") {print $0}' /etc/passwd > db2_temp

v_path1=0
v_path2=0
v_path3=0
v_path4=0
v_path5=0

if [ -s oracle_temp ]; then
  if [ -d /home/db/oracle ]; then
     v_path1=0
  else
     v_path1=1
     echo "oracle没有安装在/home/db/oracle目录下" > SYSAUD_AIX_SOFTPATH_RES1.out
  fi
fi

if [ -s informix_temp ]; then
  if [ -d /home/db/informix ]; then
     v_path2=0
  else
     v_path2=1
     echo "informix没有安装在/home/db/informix目录下" >> SYSAUD_AIX_SOFTPATH_RES1.out
  fi
fi

if [ -s weblogic_temp ]; then
  if [ -d /home/mw/weblogic ]; then
     v_path3=0
  else
     v_path3=1
     echo "weblogic没有安装在/home/mw/weblogic目录下" >> SYSAUD_AIX_SOFTPATH_RES1.out

  fi
fi

if [ -s tuxedo_temp ]; then
  if [ -d /home/mw/tuxedo ]; then
     v_path4=0
  else
     v_path4=1
     echo "tuxedo没有安装在/home/mw/tuxedo目录下" >> SYSAUD_AIX_SOFTPATH_RES1.out
  fi
fi

if [ -s db2_temp ]; then
  if [ -d /home/db/db2 ]; then
     v_path5=0
  else
     v_path5=1
     echo "db2没有安装在/home/db/db2目录下" >> SYSAUD_AIX_SOFTPATH_RES1.out
  fi
fi

rm oracle_temp
rm informix_temp
rm weblogic_temp
rm tuxedo_temp
rm db2_temp

v_num=`expr $v_path1 + $v_path2 + $v_path3 + $v_path4 + $v_path5`
if [ -s SYSAUD_AIX_SOFTPATH_RES1.out ]; then
echo "Non-Compliant"
echo "以下共有[$v_num]种软件安装路径不合规" > SYSAUD_AIX_SOFTPATH_RES.out
cat SYSAUD_AIX_SOFTPATH_RES1.out >> SYSAUD_AIX_SOFTPATH_RES.out
rm SYSAUD_AIX_SOFTPATH_RES1.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_SOFTPATH_RES.out
fi


