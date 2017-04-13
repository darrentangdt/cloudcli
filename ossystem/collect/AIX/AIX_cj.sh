#!/bin/sh
export LANG=en_US
export PATH=/usr/bin:/etc:/usr/sbin:/usr/ucb:/usr/bin/X11:/sbin:/usr/java5/jre/bin:/usr/java5/bin
filepath=/home/ap/opscloud/cj_shell
prtconf >/tmp/prtconf.txt

echo "table:CJ_SERVER"
UID_NAME=`cat ${filepath}/.uid_name`
echo "UID_NAME:${UID_NAME}"
echo "HOSTNAME:`hostname`"
echo "MANUFACTURER:IBM"
#echo "DEVICE_MODEL:$(grep "System Model" /tmp/prtconf.txt|awk -F: '{print $2}'|sed 's/ //g')"
echo "DEVICE_MODEL:$(grep "System Model" /tmp/prtconf.txt|awk -F, '{print $2}')"
sn=`grep "Machine Serial Number" /tmp/prtconf.txt|cut -d":" -f2|sed 's/ //g'`
echo "SN:${sn}"
cpu_count=`lsdev -C|grep proc|wc -l|sed 's/ //g'`
echo "CPU:${cpu_count}"
if lsuser padmin 2>/dev/null >/dev/null
then 
IS_VM=Y
else
IS_VM=N
fi
echo "IS_VM:${IS_VM}"
mem_size=`prtconf -m|awk {'print $3'}`
#mem_size=$(echo `prtconf -m|awk {'print $3'}`/1024|bc)
echo "MEM:${mem_size}"
swap_size=`lsps -s |grep MB|awk '{print $1}'|sed 's/ //g'|sed 's/MB//g'`
#swap_size=$(echo `lsps -s |grep MB|awk '{print $1}'|sed 's/ //g'|sed 's/MB//g'`/1024|bc)
echo "SWAP:${swap_size}"
echo "DISK:`lsdev -Cc disk|wc -l|sed 's/ //g'`"
echo "OS_NAME:`uname`"
echo "OS_VERSION:`oslevel`"
#echo "CJ_DATE:`date +%Y%m%d%H%M`"
echo ";"
############################################################
echo "table:CJ_CPU"
echo "UID_NAME:${UID_NAME}"
cpu_count=`lsdev -C|grep proc|wc -l|sed 's/ //g'`
echo "CPU_NUM:${cpu_count}"
core_count=`pmcycles -m|wc -l`
echo "CORE_NUM:`echo ${core_count}/${cpu_count}|bc`"
echo "FREQUENCY:`prtconf -s|cut -d":" -f2|sed 's/ //g'`"
echo "CPU_TYPE:$(grep "Processor Type" /tmp/prtconf.txt|cut -d":" -f2|sed 's/ //g')"
echo "MANUFACTURER:IBM"
echo "L2CACHESIZE:`lsattr -El L2cache0|awk '{print $2}'|sed 's/ //g'`K"
echo ";"
############################################################
echo "table:CJ_MEM"
echo "UID_NAME:${UID_NAME}"
echo "CAPACITY:`prtconf -m|awk {'print $3'}`"
echo ";"
############################################################
echo "table:CJ_DISK"
#lsdev -Cc disk|grep -v PowerPath|awk '{print $1}'|while read diskname
#lspv |awk '{print $1"  "$2}'|grep -v none|awk '{print $1}'|while read diskname
lspv|awk '{print $1}'|while read diskname
do
echo "DISK_NAME:$diskname"
echo "UID_NAME:${UID_NAME}"
#echo "DISK_SIZE:$(echo "scale=3;`bootinfo -s $diskname`/1024"|bc)"
#echo "DISK_SIZE:`bootinfo -s $diskname`"
#DISK_SIZE=`lspv ${diskname}|grep "TOTAL PPs"|awk -F'(' '{print $2}'|awk '{print $1}'`
DISK_SIZE=`getconf DISK_SIZE /dev/${diskname}`
echo "DISK_SIZE:$DISK_SIZE"
echo ","
done|sed '$d'
echo ";"
############################################################
echo "table:CJ_PV"
#lsdev -Cc disk|grep -v "PowerPath"|awk '{print $1}'|head -2|while read pvname
#lsdev -Cc disk|grep -v "PowerPath"|awk '{print $1}'|while read pvname
#do

#echo "PV_NAME:$pvname"
#echo "UID_NAME:${UID_NAME}"
#echo "VG_NAME:$(lspv $pvname|grep "VOLUME GROUP"|awk '{print $6}')"
#echo "PV_SIZE: `echo $(bootinfo -s $pvname)/1024|bc`"
#echo "PV_SIZE:`bootinfo -s $pvname`"
lspv |awk '{print $1"  "$2}'|grep -v none|awk '{print $1}'|while read pvname
do
PV_SIZE=`lspv ${pvname}|grep "TOTAL PPs"|awk -F'(' '{print $2}'|awk '{print $1}'`
echo "PV_NAME:$pvname"
echo "UID_NAME:${UID_NAME}"
echo "VG_NAME:$(lspv $pvname|grep "VOLUME GROUP"|awk '{print $6}')"
echo "PV_SIZE:$PV_SIZE"
echo ","
done|sed '$d'
echo ";"
############################################################
echo "table:CJ_VG"
lsvg -o|while read vgname
do
echo "VG_NAME:$vgname"
echo "UID_NAME:${UID_NAME}"
#echo "VG_SIZE:$(echo `lsvg $vgname |cut -c 46-|grep "PP SIZE"|awk '{print $3}'`*`lsvg $vgname |cut -c 46-|grep "TOTAL PPs"|awk '{print $3}'`/1024|bc)"
echo "VG_SIZE:$(echo `lsvg $vgname |cut -c 46-|grep "PP SIZE"|awk '{print $3}'`*`lsvg $vgname |cut -c 46-|grep "TOTAL PPs"|awk '{print $3}'`|bc)"
echo "PV_NUM:$(lsvg $vgname|cut -c0-45|grep "TOTAL PVs"|awk '{print $3}')"
echo "LV_NUM:`lsvg $vgname|cut -c0-45|grep "^LVs"|awk '{print $2}'`"
#echo "VG_FREE_SIZE:$(echo `lsvg $vgname |cut -c 46-|grep "PP SIZE"|awk '{print $3}'`*`lsvg $vgname |cut -c 46-|grep "FREE PPs"|awk '{print $3}'`/1024|bc)"
echo "VG_FREE_SIZE:$(echo `lsvg $vgname |cut -c 46-|grep "PP SIZE"|awk '{print $3}'`*`lsvg $vgname |cut -c 46-|grep "FREE PPs"|awk '{print $3}'`|bc)"
echo ","
done|sed '$d'
echo ";"
############################################################
echo "table:CJ_LV"
lsvg -o|while read vgname
do
lsvg -l $vgname|awk 'NR>2 {print $1}'|while read lvname
do
echo "LV_NAME:$lvname"
echo "UID_NAME:${UID_NAME}"
echo "VG_NAME:$vgname"
#echo "LV_SIZE:$(echo "scale=3; $(lslv -L $lvname|grep "PP SIZE"|awk '{print $6}')*$(lslv -L $lvname|grep ^LPs|awk '{print $2}')/1024"|bc)"
echo "LV_SIZE:$(echo "$(lslv -L $lvname|grep "PP SIZE"|awk '{print $6}')*$(lslv -L $lvname|grep ^LPs|awk '{print $2}')"|bc)"
echo ","
done
done|sed '$d'
echo ";"
############################################################
echo "table:CJ_FS"
lsfs|grep -v proc|awk 'NR>1 {print $3}'|while read mount_p
do
echo "FS_NAME:`lsfs $mount_p|awk 'NR>1 {print $1}'`" 
echo "UID_NAME:${UID_NAME}"
echo "LV_NAME:`lsfs -l $mount_p|awk 'NR>1 {print $1}'|awk -F "/" '{print $3}' `"
echo "MOUNT_POINT:`lsfs $mount_p|awk 'NR>1 {print $3}'`"
echo "FS_TYPE:`lsfs $mount_p|awk 'NR>1 {print $4}'`"
#echo "FS_SIZE: `df -g $mount_p|awk 'NR>1 {print $2}'`"
echo "FS_SIZE:`df -m $mount_p|awk 'NR>1 {print $2}'|sed 's/\.00//g'`"
echo ","
done|sed '$d'
echo ";"
############################################################
lsdev -Cc adapter |grep -q fcs
if [ $?  -eq 0 ]
then
echo "table:CJ_HBA"
lsdev -Cc adapter |grep "fcs"|awk '{print $1}'|while read fcname
do
  wwwn=`lscfg -vl $fcname |grep "Network Address"|awk '{print substr($2,length($2)-15,16)}'`
  hba_fw=`lscfg -vl $fcname |grep Z9|sed 's/\.*\.//g'|awk -F ")" '{print $2}'`
  #echo "\"$fcname\":\"$wwwn\"," |awk '{{printf"%s",$0}}'
  echo "HBA_NAME:$fcname"
  echo "UID_NAME:${UID_NAME}"
  echo "WWN:$wwwn"
  echo "HBA_FIRMWARE:$hba_fw"
  
  echo ","
done|sed '$d'
echo ";"
else
echo|sed '/^$/d'
fi
############################################################
echo "table:CJ_NIC"
#lsdev -Cc adapter |grep ent|grep -v fcs|grep -v scsi|awk '{print $1}'|sed 's/t//g'|while read en_name
#netstat -in|grep -v lo|awk 'NR>1 {print $1}'|uniq|while read en_name
ifconfig -a|grep ^en|awk -F: '{print $1}'|while read en_name
do
echo "NIC_NAME:$en_name"                
echo "UID_NAME:${UID_NAME}"
echo "MAC:`entstat $en_name|grep Address|awk '{print $3}'`"
echo "IPADDR:`ifconfig $en_name |grep inet|awk '{print $2}'`"
echo "ZB_IP:`ifconfig $en_name|grep inet|awk '{print $6}'`"
echo "NETMASK:`lsattr -El $en_name |grep netmask|awk '{print $2}'`"
#echo "GATEWAY:`netstat -rn |grep default|awk '{print $2}'`"
echo ","
done |sed '$d'
echo ";" 
