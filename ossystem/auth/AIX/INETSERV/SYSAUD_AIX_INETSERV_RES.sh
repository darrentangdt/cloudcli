#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_INETSERV_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查inetd服务启停                      #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_INETSERV_RES.out"
> $v_logfile

if [ "$(lssrc -a | awk '{if($2 == "ssh"){print $NF}}')" = "active" ];then
   :
else
   lssrc -a | awk '{if($2 == "ssh"){print $0}}' >> $logfile
fi

v_services="ftp
telnet
shell
kshell
login
klogin
exec
comsat
uucp
bootps
finger
systat
netstat
tftp
talk
ntalk
rquotad
rexd
rstatd
rusersd
rwalld
sprayd
pcnfsd
echo
discard
chargen
daytime
time
instsrv
imap2
pop3
wsmserveam
xmquery"

for svr in $v_services;do
    grep "^$svr" /etc/inetd.conf >> $v_logfile
done

if [ -s $v_logfile ];then
    echo "Non-Compliant"
else
    echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0
