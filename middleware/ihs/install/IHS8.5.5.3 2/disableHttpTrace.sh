#/sbin/bsh

#************************************************************************
#禁用http trace
#1、启用mod_rewrite.so模块
#	 如果mod_rewrite.so不存在，则增加
#2、为每个虚拟主机配置禁用http trace代码
#  查找所有启用的<VirtualHost和</VirtualHost所在的行
#		在每个</VirtualHost前面增加三行代码
#3、在配置文件末尾，增加三行禁用代码
#************************************************************************

#判断配置文件是否存在
if [ -r config.txt ]
then
	echo "*****************************************************************************"
	PARMS=`grep = config.txt|grep -v ^#`
	for p in $PARMS
		do
			eval p=`echo $p`
			echo $p
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

#判断参数是否缺失
Param="IHSConfigFile RunUser"
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
echo "********************************************************"
echo "*   config module   mod_rewrite.so     *"
echo "********************************************************"
#加载模块mod_rewrite.so
moduleName="LoadModule rewrite_module modules/mod_rewrite.so"
moduleNameReg="LoadModule[ ]*rewrite_module[ ]*modules/mod_rewrite.so"

moduleCount=`grep -w "$moduleNameReg" ${httpdFile} | grep -v '#' |wc -l`
if [ $moduleCount -eq 0 ]
then
	echo " Info >> \"$moduleName\" is not right,configing..."
	module_lineNum=`grep -nw "$moduleNameReg" ${httpdFile} | grep  '#' | awk -F ":" '{print $1}' | head -1`
	sed "${module_lineNum}a${moduleName}" ${httpdFile} > ${httpdFile}.tmp
	mv ${httpdFile}.tmp ${httpdFile}
	echo " Info >> \"$moduleName\" config finish"
else
	echo " Info >> \"$moduleName\" is Right"
fi

echo "********************************************************"
echo "*   config:    *"
echo "*  RewriteEngine On "
echo "*  RewriteCond %{REQUEST_METHOD} ^TRACE  "
echo "*  RewriteRule .* - [F]  "
echo "********************************************************"
index=0
lastLine=0
grep -n VirtualHost ${httpdFile} |grep '<' |grep '>' |grep -v '#' |awk -F ":" '{print $1}'| tac | while read line
	do
		index=`expr $index + 1`
		if [ `expr $index % 2` -eq 0 ]
		then
			RewriteCond=`sed -n "${line},${lastLine}p" ${httpdFile} | grep RewriteCond`
			if [ "${RewriteCond}" == "" ]
			then
				sed "${lastLine}iRewriteRule .* - [F]" ${httpdFile} > ${httpdFile}.tmp
				mv ${httpdFile}.tmp ${httpdFile}
				sed "${lastLine}iRewriteCond %{REQUEST_METHOD} ^TRACE " ${httpdFile} > ${httpdFile}.tmp
				mv ${httpdFile}.tmp ${httpdFile}
				sed "${lastLine}iRewriteEngine On" ${httpdFile} > ${httpdFile}.tmp
				mv ${httpdFile}.tmp ${httpdFile}
				
				sed "${lastLine}i#禁用HttpTrace" ${httpdFile} > ${httpdFile}.tmp
				mv ${httpdFile}.tmp ${httpdFile}
				
				echo " Info >> config Sucessed。line ${line}-${lastLine}"
			else
				echo " Warn >> it seems that 'RewriteCond' has configured,you shoud config yourself。line ${line}-${lastLine}"
			fi
		fi
		lastLine=$line
done

echo "#禁用HttpTrace" >> ${IHSConfigFile}
echo "RewriteEngine On" >> ${IHSConfigFile}
echo "RewriteCond %{REQUEST_METHOD} ^TRACE" >> ${IHSConfigFile}
echo "RewriteRule .* - [F]" >> ${IHSConfigFile}


