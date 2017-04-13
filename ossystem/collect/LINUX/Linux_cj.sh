#!/bin/bash
export PATH=/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/usr/bin
export LANG=en_US 
filepath=/home/ap/opscloud/cj_shell
UID_NAME=`cat $filepath/.uid_name`

###############CJ_SERVER##############################################
cj_server()
{
echo "table:CJ_SERVER"
echo "UID_NAME:"$UID_NAME
echo "HOSTNAME:`hostname`"
echo "SN:`dmidecode -t system |grep -i 'Serial Number'| awk -F: '{print $2}'|sed 's/ //g'`"
echo "MANUFACTURER:`dmidecode -t system |grep Manufacturer|awk -F: '{print $2}'`"
echo "DEVICE_MODEL:`dmidecode -t system |grep -i 'Product Name'|awk -F: '{print $2}'`"
systype=`dmidecode -t system |grep -i 'Manufacturer'| awk -F: '{print $2}'`
if [ ${systype:0:7} = "VMware" ];then
    v_vmstatus="y"
    echo "IS_VM:$v_vmstatus"
  else
    v_vmstatus="n"
    echo "IS_VM:$v_vmstatus"
fi
MEM=`echo $(dmidecode |grep -A16 "Memory Device$"|grep Size|grep -v "No "|awk '{ sum+=$2} END{print sum}')`
echo  "CPU:`cat /proc/cpuinfo |grep "processor"|sort |uniq|wc -l`"
echo  "MEM:"$MEM
echo  "SWAP:`free -m | sed -n 4p|awk '{print $2}'`"
echo  "DISK:`fdisk -l| grep Disk|wc -l`"
echo  "OS_NAME:`cat /etc/redhat-release|awk '{print $1,$2,$3,$4}'`"
echo  "OS_VERSION:`cat /etc/redhat-release|awk '{print $7}'`"
#echo  "CJ_DATE:`date +%F`"
echo  ";"
}
##############CJ_CPU###################################################
cj_cpu()
{
echo "table:CJ_CPU"
echo "UID_NAME:"$UID_NAME
echo  "CPU_NUM:`cat /proc/cpuinfo |grep "physical id"|uniq|wc -l`"
echo  "CORE_NUM:`cat /proc/cpuinfo |grep "cpu cores"|uniq| awk  '{print $4}'`"
echo  "FREQUENCY:`cat /proc/cpuinfo | grep "cpu MHz" | awk -F: '{print $2}' |uniq`"
echo  "CPU_TYPE:`cat /proc/cpuinfo | grep "model name" | awk -F: '{print $2}' | head -1 | awk -F@ '{print $1}'|sed 's/ //g'`"
echo  "MANUFACTURER:`cat /proc/cpuinfo | grep "model name" | awk -F: '{print $2}' | head -1 | awk  '{print $1}'`"
echo  "L2CACHESIZE:`cat /proc/cpuinfo | grep "cache size" | head -1 | awk -F: '{print $2}'`"
echo ";"

}
##############CJ_MEM####################################################
cj_mem()
{
echo "table:CJ_MEM"
echo "UID_NAME:"$UID_NAME
echo "CAPACITY:"$MEM
echo ";"
}
##############CJ_DISK###################################################
cj_disk()
{
echo "table:CJ_DISK"
fdisk -l|grep  "Disk"|grep -v mapper|grep -v identifier|while read line
do
 echo "DISK_NAME:"`echo $line|awk '{print $2}'|sed 's/://g'`
 echo "UID_NAME:"$UID_NAME
 DISK_SIZE=`echo $line|awk '{print $3}'`
 DISK_SIZE=`echo ${DISK_SIZE}*1024|bc`
 echo "DISK_SIZE:"${DISK_SIZE%%.*}
 echo "DISK_TYPE:Local"
 echo ","
done|sed  '$d'
echo ";"
}
##############CJ_PV###################################################

cj_pv()
{
echo "table:CJ_PV"
pvs --units m|grep -v "PF"|while read line
do
 echo "PV_NAME:"`echo $line|awk '{print $1}'`
 echo "UID_NAME:"$UID_NAME
 echo "VG_NAME:"`echo $line|awk '{print $2}'`
 PV_SIZE=`echo $line|awk '{print $5}'|sed 's/[m|M]//g'`
 echo "PV_SIZE:"${PV_SIZE%%.*}
 echo ","
done|sed  '$d'
echo ";"
}
##############CJ_VG###################################################
cj_vg()
{
echo "table:CJ_VG"
vgs --units m|grep -v "VF"|while read line
do
echo  "VG_NAME:"`echo $line| awk '{print $1}'`
echo  "UID_NAME:"$UID_NAME
VG_SIZE=`echo $line| awk '{print $6}'|sed 's/[m|M]//g'`
echo  "VG_SIZE:"${VG_SIZE%%.*}
echo  "PV_NUM:"`echo $line| awk '{print $2}'`
echo  "LV_NUM:"`echo $line| awk '{print $3}'`
VG_FREE_SIZE=`echo $line| awk '{print $7}'|sed 's/[m|M]//g'`
echo  "VG_FREE_SIZE:"${VG_FREE_SIZE%%.*}
echo  ","
done|sed  '$d'
echo ";"
}

##############CJ_LV###################################################
cj_lv()
{
echo "table:CJ_LV"
lvs --units m |grep -v "LS"|while read line
do
echo  "LV_NAME:"`echo $line| awk '{print $1}'`
echo  "UID_NAME:"$UID_NAME
echo  "VG_NAME:"`echo $line| awk '{print $2}'`
LV_SIZE=`echo $line| awk '{print $4}'|sed 's/[m|M]//g'`
echo  "LV_SIZE:"${LV_SIZE%%.*}
echo  ","
done|sed  '$d'
echo ";"
}

##############CJ_FS###################################################
cj_fs()
{
echo "table:CJ_FS"
df -mTP|grep -v "Used"|while read line
do
FS_NAME=`echo $line|awk '{print $1}'`
echo  "FS_NAME:"$FS_NAME
echo  "UID_NAME:"$UID_NAME
FS_SIZE=`echo $line|awk '{print $3}'`
echo  "FS_SIZE:"${FS_SIZE%%.*} 
echo  "FS_TYPE:"`echo $line|awk '{print $2}'`
echo  "MOUNT_POINT:"`echo $line|awk '{print $7}'`
echo	"LV_NAME:"`echo ${FS_NAME##*/}`
echo  ","
done|sed  '$d'
echo ";"
}

##############CJ_NIC##################################################
cj_nic()
{
echo "table:CJ_NIC"
/sbin/ifconfig | awk '/^eth|^em|^bond/{print $1}' |while read v_ethx;do
echo  "UID_NAME:$UID_NAME"
echo "NIC_NAME:$v_ethx"
echo "ZB_IP:"`ifconfig $v_ethx|grep Bcast|awk -F" " '{print $3}'|cut -d: -f2`
echo "IPADDR:$(/sbin/ifconfig $v_ethx | grep "inet addr:" |awk -F: '{print $2}'|awk '{print $1}')"
echo "MAC:"`ifconfig $v_ethx|grep "HWaddr"|awk -F" " '{print $NF}'`
echo "NETMASK:"`ifconfig $v_ethx|grep  "Mask:"|awk -F: '{print $NF}'`
echo ","
done|sed '$d'
echo ";"
}
##############CJ_HBA##################################################
cj_hba()
{
systool -p|grep fc_host 2>&1 1>/dev/null
if [ $? -eq 0 ]
#if systool -c fc_host
then
echo "table:CJ_HBA"
for i in `systool -c fc_host | grep "Class Device" |awk -F= '{print $2}'|sed 's/"//g'`;do
echo "HBA_NAME:"$i
echo "UID_NAME:":$UID_NAME
echo "WWN:"`cat /sys/class/fc_host/$i/port_name`
echo ","
done|sed '$d'
echo ";"
else
:
fi
}

which dmidecode 1>/dev/null
if [ $? -ne 0 ]
then
	echo "dmidecode is not install"
	exit 1
else
cj_server
cj_cpu
cj_mem
cj_disk
cj_pv
cj_vg
cj_lv
cj_fs
cj_nic
cj_hba
fi
