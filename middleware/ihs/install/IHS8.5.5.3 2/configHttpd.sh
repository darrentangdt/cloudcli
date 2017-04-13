#/sbin/bsh

#************************************************************************
#IHS����
#1������־�滻Ϊѭ����־��ÿ��һ����־�ļ�
#2����ServerSignature Off�滻ΪServerSignature On
#3��������Option������ΪNone
#  	��������δע�͵�Optionsѡ�ȫ���ԡ�Options None���滻
#4����ServerTokens XXX�滻ΪServerTokens Prod
#	 ��������δע�͵�ServerTokensѡ�ȫ���ԡ�ServerTokens Prod���滻
#************************************************************************

echo " Info >> Config ${httpdFile} begin...."
LocalDate=`date '+%Y%m%d%H%M%S'`

#�ж������ļ��Ƿ����
if [ -r config.txt ]
then
	echo "*****************************************************************************"
	PARMS=`grep = config.txt|grep -v ^#`
	for p in $PARMS
		do
			eval p=`echo $p`
			#echo $p
			export $p
		done
	echo "*****************************************************************************"
else
	echo "Error >> config file check failed! there is no config.txt file!"
	exit -1
fi

#IHSConfigFile="/wasProgram/httpd.conf"
#RunUser="wasup

if [ ! -f $IHSConfigFile ]
then
	echo "	Error >> the file ${IHSConfigFile} is not exist"
	exit -1
fi

curUser=`whoami`
if [ "${curUser}" != "$RunUser" ]
then
	echo "	Error >> you must use: $RunUser to run this script"
	exit 1
fi

#�жϲ����Ƿ�ȱʧ
Param="IHSConfigFile IHS_HOME LOG_HOME RunUser"
for p in $Param
	do
		eval var=$`echo $p`
		if [ "${var}" == "" ]
		then
			echo " Error >> $p is null"
			return 
		fi
done


httpdFolder=`dirname $IHSConfigFile`
httpdFile=`basename $IHSConfigFile`

cd ${httpdFolder}
echo " Info >> backup ${IHSConfigFile} to ${IHSConfigFile}.$LocalDate.tar"
tar -cvf ${httpdFile}.$LocalDate.tar ${httpdFile}

cd ${IHS_HOME}/htdocs
echo "Info >> delete htdocsfiles....."
rm -rf *
echo "Info >> Sucess"

echo "	Info >> config ErrorLog and CustomLog....."
sed 's:ErrorLog logs/error_log:ErrorLog  "|'$IHS_HOME'/bin/rotatelogs '$LOG_HOME'/error%Y%m%d%H.log 86400":' ${httpdFolder}/${httpdFile} > ${httpdFolder}/${httpdFile}.tmp
mv ${httpdFolder}/${httpdFile}.tmp ${httpdFolder}/${httpdFile}
sed 's:CustomLog logs/access_log common:CustomLog "|'$IHS_HOME'/bin/rotatelogs '$LOG_HOME'/access%Y%m%d%H.log 86400" combined:' ${httpdFolder}/${httpdFile} > ${httpdFolder}/${httpdFile}.tmp
mv ${httpdFolder}/${httpdFile}.tmp ${httpdFolder}/${httpdFile}
echo "	Info >> Sucess"

echo "	Info >> change 'ServerSignature On' to  'ServerSignature Off'....."
sed 's:ServerSignature On:ServerSignature Off:' ${httpdFolder}/${httpdFile} > ${httpdFolder}/${httpdFile}.tmp
mv ${httpdFolder}/${httpdFile}.tmp ${httpdFolder}/${httpdFile}
echo "	Info >> Sucess"

echo "	Info >> config 'Options XXXX' to 'Options None'....."
grep -w Options ${httpdFolder}/${httpdFile}|grep -v "#"|while read option
	do
		echo "		Info >> replay '" $option "' to 'Options None'"
		sed "s:$option:Options None:" ${httpdFolder}/${httpdFile} > ${httpdFolder}/${httpdFile}.tmp
		mv ${httpdFolder}/${httpdFile}.tmp ${httpdFolder}/${httpdFile}
done
echo "	Info >> Sucess"

echo "	Info >> config 'ServerTokens XXXX' to 'ServerTokens None'....."
grep -w ServerTokens ${httpdFolder}/${httpdFile}|grep -v "#"|while read option
	do
		echo "		Info >> replay '" $option "' to 'ServerTokens Prod'"
		sed "s:$option:ServerTokens Prod:" ${httpdFolder}/${httpdFile} > ${httpdFolder}/${httpdFile}.tmp
		mv ${httpdFolder}/${httpdFile}.tmp ${httpdFolder}/${httpdFile}
done
echo "	Info >> Sucess"

echo "	Info >> config 'DefaultType None' to 'DefaultType text/plain'....."
grep -w DefaultType ${httpdFolder}/${httpdFile}|grep -v "#"|while read DefaultType
	do
		sed "s:DefaultType None:DefaultType text/plain:" ${httpdFolder}/${httpdFile} > ${httpdFolder}/${httpdFile}.tmp
		mv ${httpdFolder}/${httpdFile}.tmp ${httpdFolder}/${httpdFile}
done
echo "	Info >> Sucess"

echo " Info >> Config ${httpdFile} end"

