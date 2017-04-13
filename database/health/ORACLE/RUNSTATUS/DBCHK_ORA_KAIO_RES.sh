#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
################################################################
###Write by liuwen 2012.7.30
###This script is a health check script of aix,hp-ux system KAIO
################################################################
rm -f $log_dir/DBCHK_ORA_KAIO_RES.out;

systemtype=`uname -a |awk '{print $1}'`
if [ "$systemtype" = "AIX" ];then
  systemversion=`uname -a |awk '{print $4}'`;
  if [ "$systemversion" -eq 5 ];then
   a=`lsattr -El aio0|grep autoconfig|awk '{print $2}'`
   if [ $a! = "available" ]
   then
      echo "Non-Compliant";
      echo AIX-`hostname`: "没有启动KAIO">$log_dir/DBCHK_ORA_KAIO_RES.out;
   else 
      echo "Compliant";
      echo AIX-`hostname`: "KAIO已经开启">$log_dir/DBCHK_ORA_KAIO_RES.out;
      exit 0;  
   fi
  fi
  echo "Compliant";
  echo AIX-`hostname`: "KAIO已经开启">$log_dir/DBCHK_ORA_KAIO_RES.out;
  exit 0;
fi
systemtype=`uname -a |awk '{print $1}'`
if [ "$systemtype" = "HP-UX" ];then
   b=`fuser /dev/async 2>&1| wc -l |grep -v 'dev'`
   #echo $b
   if [ $b -eq 0 ]
   then
       echo "Non-Compliant";
       echo HP-`hostname`: "没有启动KAIO">$log_dir/DBCHK_ORA_KAIO_RES.out;
   fi
   echo "Compliant";
   echo HP-`hostname`: "KAIO已经开启">$log_dir/DBCHK_ORA_KAIO_RES.out;
   exit 0;  
else
echo "Log";
echo "本操作只针对AIX/UP-UX操作系统" >$log_dir/DBCHK_ORA_KAIO_RES.out;
exit 0;
fi
