#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_OSSECUR_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统安全方面的启停                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_dhcpd=`lssrc -g tcpip |sed -n '/dhcpcd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_ndpdhost=`lssrc -g tcpip |sed -n '/ndpd-host/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_ndpdrouter=`lssrc -g tcpip |sed -n '/ndpd-router/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_routed=`lssrc -g tcpip |sed -n '/routed/{p;n;}' |grep -v "mrouted" |awk '{print $NF}'`
v_gated=`lssrc -g tcpip |sed -n '/gated/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_inetd=`lssrc -g tcpip |sed -n '/inetd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_named=`lssrc -g tcpip |sed -n '/named/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_timed=`lssrc -g tcpip |sed -n '/timed/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_xntpd=`lssrc -g tcpip |sed -n '/xntpd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_rwhod=`lssrc -g tcpip |sed -n '/rwhod/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_snmpd=`lssrc -g tcpip |sed -n '/snmpd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_dhcpsd=`lssrc -g tcpip |sed -n '/dhcpsd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_dhcprd=`lssrc -g tcpip |sed -n '/dhcprd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_dpid2=`lssrc -g tcpip |sed -n '/dpid2/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_hostmibd=`lssrc -g tcpip |sed -n '/hostmibd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_aixmibd=`lssrc -g tcpip |sed -n '/aixmibd/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_mrouted=`lssrc -g tcpip |sed -n '/mrouted/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_pxed=`lssrc -g tcpip |sed -n '/pxed/{p;n;}' |head -n 1 |awk '{print $NF}'`
v_binld=`lssrc -g tcpip |sed -n '/binld/{p;n;}' |head -n 1 |awk '{print $NF}'`

if [ $v_dhcpd != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/dhcpcd/{p;n;}' > SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_ndpdhost != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/ndpd-host/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_ndpdrouter != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/ndpd-router/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_routed != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/routed/{p;n;}' |grep -v "mrouted"  >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_gated != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/gated/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_inetd != "active" ]; then
  lssrc -g tcpip |sed -n '/inetd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_named != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/named/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_timed != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/timed/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_xntpd != "active" ]; then
  lssrc -g tcpip |sed -n '/xntpd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_rwhod != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/rwhod/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_snmpd != "active" ]; then
  lssrc -g tcpip |sed -n '/snmpd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_dhcpsd != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/dhcpsd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_dhcprd != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/dhcprd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_dpid2 != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/dpid2/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_hostmibd != "active" ]; then
  lssrc -g tcpip |sed -n '/hostmibd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_aixmibd != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/aixmibd/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_mrouted != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/mrouted/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_pxed != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/pxed/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ $v_binld != "inoperative" ]; then
  lssrc -g tcpip |sed -n '/binld/{p;n;}' >> SYSAUD_AIX_OSSECUR_RES1.out
  fi

if [ -s SYSAUD_AIX_OSSECUR_RES1.out ]; then
echo "Non-Compliant"
echo "以下TCPIP的子服务状态不合规" > SYSAUD_AIX_OSSECUR_RES.out
echo "Subsystem         Group            PID          Status" >> SYSAUD_AIX_OSSECUR_RES.out
cat  SYSAUD_AIX_OSSECUR_RES1.out >>  SYSAUD_AIX_OSSECUR_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_OSSECUR_RES.out
fi
rm -f SYSAUD_AIX_OSSECUR_RES1.out
