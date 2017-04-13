
import sys
import re
import sre

WCPropertys=[]
JVMPropertys=[]
#���ϲ���ɾ��

##############################  WAS Server ���� ##############################
serverName = "server1"


#�̳߳�
webThreadPoolMinSize = "100"				#Ĭ��Ϊ10
webThreadPoolMaxSize = "150"			#Ĭ��Ϊ50

#Session����
enableCookies='true'		#����cookie���أ�wasĬ��Ϊtrue
cookieSecure='false'			#����cookie��Secure���ԣ�wasĬ��Ϊfalse������Ӧ�ó���ֻͨ��https����
cookiehttpOnly='true'		#����cookie��httpOnly������Ϊtrue��was8.XĬ��Ϊtrue��WAS7�����°汾�޸�ѡ�񣬿�ͨ��Web����������������

#Web�����������ԣ���ȫ��ע��
#WCPropertys= WCPropertys + [["com.ibm.ws.webcontainer.channelwritetype" , "sync"]]
#����was6.1.0.43��was7.0.0.9���ϰ汾����cookie��httpOnly���ԣ�Ҳ������Ӧ�ó����Լ���cookie���ã�*����ָ��Ϊ����cookie���ƣ�������Ӣ�Ķ��ŷָ�
#WCPropertys= WCPropertys + [["com.ibm.ws.webcontainer.HTTPOnlyCookies" , "*"]]

#JVM��classpath�������ڶ�������ʹ��Ӣ��;�ֺŸ���
jvmClassPath = ""
jvmVerboseGC = "TRUE"			#��ϸ�������գ�����Ҫ��ΪTRUE
jvmInitHeapSize = "1024"		#Ĭ��Ϊ64������Ҫ����С��512
jvmMaxHeapSize = "2048"		#Ĭ��Ϊ256������Ҫ����С��1024
jvmGenericArguments = "-Djava.awt.headless=true -Xgcpolicy:gencon -Xmns512M -Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=8050 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djavax.management.builder.initial="

#WAS��־���ã������иÿ������һ����־�ļ�
systemOutLogFile = "C:/log/WebSphere/AppServer/SystemOut.log"
systemErrLogFile = "C:/log/WebSphere/AppServer/SystemErr.log"
baseHour = "24"
historyFileCount = "30"		#��־����������������־������gz��ѹ�������ò�������������
stdOutLogFile = "C:/log/WebSphere/AppServer/native_stdout.log"
stdErrLogFile = "C:/log/WebSphere/AppServer/native_stderr.log"

#server������Ŀ����ȫ��ע�ͣ����������뱣�������и�������ϵ�м�����ȷ��
JVMPropertys= JVMPropertys + [["IBM_HEAPDUMPDIR" , "D:/log/WebSphere/AppServer/dump"]]		#�ض���heapdump����Ŀ¼
JVMPropertys= JVMPropertys + [["IBM_JAVACOREDIR" , "D:/log/WebSphere/AppServer/dump"]]		#�ض���javacore����Ŀ¼
JVMPropertys= JVMPropertys + [["IBM_HEAPDUMP_OUTOFMEMORY" , "TRUE"]]
JVMPropertys= JVMPropertys + [["IBM_JAVADUMP_OUTOFMEMORY" , "TRUE"]]


#����ִ�����ã�����wasʹ��wasup�û�����������Ҫ�޸�
processPriorityValue = "20"
umaskValue = "022"
user = ""
group = ""

#Ĭ��jdbc�ṩ�ߺ�Ĭ��Ӧ�ã�����Ҫ�޸ģ������Ѿ�ɾ�����ű���������
derbyJDBCProvider = "Derby JDBC Provider"
defaultApp1 = "DefaultApplication"
defaultApp2 = "ivtApp"
defaultApp3 = "query"

##############################  WAS Server ���� ##############################


def regexp(pattern, string, flags=0):
        if(re.compile(pattern, flags).search(string)==None): return 0
        else: return 1

def regexpn(pattern, string, flags=0):
        r = re.compile(pattern, flags).subn("", string)
        return r[1]

def wsadminToList(inStr):
        outList=[]
        if (len(inStr)>0 and inStr[0]=='[' and inStr[-1]==']'):
                tmpList = inStr[1:-1].split() #splits space-separated lists,
        else:
                tmpList = inStr.split("\n")   #splits for Windows or Linux
        for item in tmpList:
                item = item.rstrip();         #removes any Windows "\r"
                if (len(item)>0):
                        outList.append(item)
        return outList
#endDef


#############################################
#    Set the Configration Paramaters        #
#############################################

cellName=AdminControl.getCell()		#����ָ������cellName
nodeName=AdminControl.getNode()		#����ָ������nodeName

#######################################################
# remove default apps
#######################################################
apps=wsadminToList(AdminApp.list())
for app in apps :
	if ( app == defaultApp1 or app == defaultApp2 or app == defaultApp3 ) :
		print "	Info >> uninstalling app : " + app
		AdminApp.uninstall('%s'%(app))
		print "		Info >> Successfull "
	#end if
#end for
AdminConfig.save( )


###################################
#  Modify WebContainer Settings   #
###################################
print "	Info >> Modifying Application Server "+serverName+" 's WebContainer Settings....."
server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
threadPool = AdminConfig.list("ThreadPool", server )
threadPool = wsadminToList(threadPool);

webContainer = ""

for thread in threadPool:
	if (regexp("WebContainer", thread) == 1):
		webContainer = thread
	#endIf
#endFor

if webContainer!="":
	webThreadPool_max_attribute = ["maximumSize", webThreadPoolMaxSize]
	webThreadPool_min_attribute = ["minimumSize", webThreadPoolMinSize]
	webThreadPoolAttributes = [webThreadPool_max_attribute, webThreadPool_min_attribute]
	AdminConfig.modify(webContainer, webThreadPoolAttributes )
	AdminConfig.save( )
	print "		Info >> Successfull "
else:
	print "		Error >>  WebContainer not found"

###################################
#       Modify JVM Settings       #
###################################
print "	Info >> Modifying Application Server "+serverName+" 's JVM Settings....."
server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
JVM = AdminConfig.list("JavaVirtualMachine", server )
jvm_max_attribute = ["maximumHeapSize", jvmMaxHeapSize]
jvm_init_attribute = ["initialHeapSize", jvmInitHeapSize]
jvm_gc_attribute = ["verboseModeGarbageCollection", jvmVerboseGC]

jvm_genericJvmArgs_attribute = ["genericJvmArguments", jvmGenericArguments]

jvmClassPath_attr = ["classpath", jvmClassPath]
jvmAttributes = [jvm_max_attribute, jvm_init_attribute, jvm_genericJvmArgs_attribute, jvmClassPath_attr,jvm_gc_attribute]

AdminConfig.unsetAttributes(JVM,["classpath","genericJvmArguments"])
print "	Info >> unsetAttribute 'jvmClasspath' and 'genericJvmArguments'"
AdminConfig.modify(JVM, jvmAttributes )

AdminConfig.save( )
print "		Info >> Successfull "
#######################################################
#    Modify server 's JVM ProcessExecution            #
#######################################################
print "	Info >> Modifying "+cellName+" -> "+nodeName+" -> "+serverName+" 's ProcessExecution ....."
server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
processDef = AdminConfig.list("JavaProcessDef", server )
execution = AdminConfig.showAttribute(processDef, "execution" )

processPriority_attr = ["processPriority", processPriorityValue]
umask_attr = ["umask", umaskValue]
runAsUser_attr = ["runAsUser", user]
runAsGroup_attr = ["runAsGroup", group]

execution_attrs = [processPriority_attr, umask_attr, runAsUser_attr, runAsGroup_attr]
AdminConfig.modify(execution, execution_attrs )
AdminConfig.save( )
print "		Info >> Successfull "

####################################################
#    Remove JDBC Provider        scope server  #
####################################################
print "	Info >> Removing Server "+serverName+" JDBCProvider "+derbyJDBCProvider+"....."
jdbcProvider = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName+"/JDBCProvider:"+derbyJDBCProvider+"/" )

if jdbcProvider!="":
	AdminConfig.remove(jdbcProvider )
	AdminConfig.save( )
	print "		Info >> Successfully "
else:
	print "		Warn >> JDBCProvider ("+derbyJDBCProvider+") is not found"

#######################################################
#    Modify SystemOut and SystemErr Log's Attributes  #
#######################################################
print "	Info >> Modifying Application Server "+serverName+" 's SystemOut and SystemErr Log's PATH ....."
server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
systemerr = AdminConfig.showAttribute(server, "errorStreamRedirect" )
systemout = AdminConfig.showAttribute(server, "outputStreamRedirect" )
systemerr_attribute = ["fileName", systemErrLogFile]
systemout_attribute = ["fileName", systemOutLogFile]
systemerr_attributes = [systemerr_attribute, ["rolloverType", "TIME"], ["baseHour", baseHour], ["maxNumberOfBackupFiles", historyFileCount]]
systemout_attributes = [systemout_attribute, ["rolloverType", "TIME"], ["baseHour", baseHour], ["maxNumberOfBackupFiles", historyFileCount]]
AdminConfig.show(systemout )
AdminConfig.modify(systemerr, systemerr_attributes )
AdminConfig.modify(systemout, systemout_attributes )
AdminConfig.save( )
print "		Info >> Successfull"

###########################################################
#    Modify native_stdout and native_stderr's Attributes  #
###########################################################
print "	Info >> Modifying Application Server "+serverName+" 's native_stdout and native_stderr Log's PATH ....."
server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
processDef = AdminConfig.list("JavaProcessDef", server )
ioRedirect = AdminConfig.showAttribute(processDef, "ioRedirect" )

errFile = ["stderrFilename", stdErrLogFile]
errAttr = [errFile]
outFile = ["stdoutFilename", stdOutLogFile]
outAttr = [outFile]

AdminConfig.modify(ioRedirect, errAttr)
AdminConfig.modify(ioRedirect, outAttr)
AdminConfig.save( )
print "		Info >> Successfull"

#######################################################
#    Modify server 's ProcessDef's Environment Entry  #
#    Add HeapDump & JavaCore Config Parameter         #
#######################################################

print "	Info >> Modifying "+serverName+" 's Heapdump & JavaCore Config Parameter  ....."

server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
processDef = AdminConfig.list("JavaProcessDef", server )


for p in JVMPropertys :
	name = p[0]
	value = p[1]
	props=wsadminToList(AdminConfig.list("Property",processDef))
	for prop in props :
		exitName=AdminConfig.showAttribute(prop,'name')
		if ( exitName == name) :
			print "	Info >> removing " + name
			AdminConfig.remove(prop)
			AdminConfig.save( )
			print "		Info >> Successfull "
		#end if
	#end for
	print "	Info >> add JVM Property :" + name + "=" + value
	varName = ["name", name]
	varValue = ["value", value]
	customPropAttrs = [varName, varValue]
	AdminConfig.create("Property", processDef, customPropAttrs )
	AdminConfig.save( )
	print "		Info >> Sucessfull"
#end for

#######################################################
#    Create WebContainer Property
#######################################################
print "	Info >> Create "+serverName+"'s WebContainer Property   ....."

webContainerProperties = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName+"/ApplicationServer:/WebContainer:/")
for p in WCPropertys :
	name = p[0]
	value = p[1]
	pList = wsadminToList(AdminConfig.list("Property" , webContainerProperties))
	for prop in pList :
		exitName=AdminConfig.showAttribute(prop,'name')
		if ( exitName == name) :
			print "		Info >> removing " + name
			AdminConfig.remove(prop)
			AdminConfig.save( )
			print "			Info >> Successfull "
		#end if
	#end for
	print "	Info >> add WebContain Property :" + name + "=" + value
	AdminConfig.create("Property", webContainerProperties, [["name", name],["value", value]] )
	AdminConfig.save( )
	print "		Info >> Sucessfull"

######################################
#  Modify Session and Cookie config  #
######################################
#��ȡWAS���汾��
version = AdminTask.getNodeMajorVersion("-nodeName " + nodeName)
server = AdminConfig.getid("/Cell:"+cellName+"/Node:"+nodeName+"/Server:"+serverName )
SessionManager = AdminConfig.list("SessionManager", server )

print "	Info >> modify enableCookies=" + enableCookies
AdminConfig.modify(SessionManager, [["enableCookies" , enableCookies]] )
AdminConfig.save()
print "		Info >> Sucess"

Cookie = AdminConfig.list("Cookie", SessionManager )
print "	Info >> modify cookieSecure=" + cookieSecure
AdminConfig.modify(Cookie, [["secure" , cookieSecure]] )
AdminConfig.save()
print "		Info >> Sucess"

if version == '8' :
	print "	Info >> modify cookiehttpOnly=" + cookiehttpOnly
	AdminConfig.modify(Cookie, [["httpOnly" , cookiehttpOnly]] )
AdminConfig.save()
print "		Info >> Sucess"

print "Info >> Config Server Finish"
