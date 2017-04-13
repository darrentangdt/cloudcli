#!/bin/sh
#************************************************
# �ļ�����SECAUD_HPUX_SYSCONFACL_RES.sh             
# ���Թ��������չ�����ȫ����Ⱥ��            
# �ű�׫д������������ƽ̨��Ŀ��                               
# ��  �ڣ�2014��3��10��                                 
# ��  �ܣ����ϵͳ�����ļ�Ȩ��                         
#************************************************

#�����ʱ�ű����Ŀ¼�Ƿ����
v_golbalpath=/home/ap/opsware/agent/scripts/SECURITY/HPUX
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
	mkdir -p /home/ap/opsware/script/tmp
	cd /home/ap/opsware/script/tmp
fi

if [ -f SECAUD_HPUX_SYSCONFACL_RES.out ]; then
	rm -f SECAUD_HPUX_SYSCONFACL_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

echo ԭʼ��Ϣ>>SECAUD_HPUX_SYSCONFACL_RES.out
echo ----->>SECAUD_HPUX_SYSCONFACL_RES.out
echo Ȩ�޼�������Ϣ:>>SECAUD_HPUX_SYSCONFACL_RES.out


#1.���ϵͳ�����ļ�Ȩ��.

#��鵥���ļ�
filelist=`grep F\| $v_golbalpath/HPUX_SEC_PARA.txt| awk -F\| '{print $2}'`
for i in $filelist; do
ls -al $i|awk '{print $NF"|"$3"|"$4"|"$1}' >>SECAUD_HPUX_SYSCONFACL_RES.out
ls -al $i|awk '{print $NF"|"$3"|"$4"|"$1}'>>temp.out
done

echo ----->>SECAUD_HPUX_SYSCONFACL_RES.out
echo �м���Ϣ>>SECAUD_HPUX_SYSCONFACL_RES.out
echo ----->>SECAUD_HPUX_SYSCONFACL_RES.out

echo �����ļ�Ȩ�ޡ��������Ϲ� >>SECAUD_HPUX_SYSCONFACL_RES.out
#�г����Ϲ�ĵ����ļ�
for i in `cat temp.out`;do
var1=`echo $i|awk -F\| '{print "F""|"$1"|"$2"|"$3}'`
attr=`echo $i|awk -F\| '{print $4}'`
attrsys=`grep $var1 $v_golbalpath/HPUX_SEC_PARA.txt|awk -F\| '{print $5}'`
echo "$attrsys"|grep -q ".$attr"
if [ $? -eq 0 ]; then
echo nothing>/dev/null 2>&1
else 
echo "$i"|awk -F\| '{print $1}'  >>SECAUD_HPUX_SYSCONFACL_RES.out
echo "$i"|awk -F\| '{print $1}' >>Conviction.out
fi
done

echo ----->>SECAUD_HPUX_SYSCONFACL_RES.out
echo ���ս���>>SECAUD_HPUX_SYSCONFACL_RES.out
echo ----->>SECAUD_HPUX_SYSCONFACL_RES.out

#���ܳ���û��Υ������Ҳ����Conviction�ļ�����������ͨ�����ص��������ж��Ƿ���Υ������
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#3.����Conviction���ڲ���������Ϊ0���õ����ս��.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		echo "���Ϲ�" >> SECAUD_HPUX_SYSCONFACL_RES.out
	else
		echo "Compliant"
		echo "�Ϲ�" >> SECAUD_HPUX_SYSCONFACL_RES.out
	fi
else 
	echo "Compliant"
	echo "�Ϲ�" >> SECAUD_HPUX_SYSCONFACL_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f temp.out ]; then
	rm -f temp.out
fi

exit 0;
