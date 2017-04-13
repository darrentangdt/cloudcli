#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_TCPRECV_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统参数tcp_recvspace设置          #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_TCPRECV_RES.out"
> $v_logfile
no -aF | awk -F= '/tcp_recvspace/{if ($2 == 262144){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile

if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "系统参数当前值为[$(no -aF | awk -F= '/tcp_recvspace/{print $0}')], 未设置为[262144],属不合规" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0









no -aF | awk -F= '/tcp_recvspace/{if ($2 == 262144){print $1"\tis\t"$2"\t\t\t\t\tOK"}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}'
v_tcprecv=`no -o tcp_recvspace |awk -F= '{print $2}'`
v_p1=`grep "V_AIX_AUD_TCPRECV" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`

if [ $v_tcprecv -eq "$v_p1" ]; then
echo "Compliant"
echo "合规" > SYSAUD_AIX_TCPRECV_RES.out
else
echo "Non-Compliant"
echo "系统参数tcp_recvspace当前值为[$v_tcprecv],未设置为[$v_p1],属不合规" > SYSAUD_AIX_TCPRECV_RES.out
fi





