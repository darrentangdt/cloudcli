
import sys
import re
import sre

WCPropertys=[]
JVMPropertys=[]
#以上不可删除

##############################  WAS Server 参数 ##############################
serverName = "server1"


#线程池
webThreadPoolMinSize = "100"				#默认为10
webThreadPoolMaxSize = "150"			#默认为50

#Session配置
enableCookies='true'		#启用cookie开关，was默认为true
cookieSecure='false'			#设置cookie的Secure属性，was默认为false；如果应用程序只通过https访问
cookiehttpOnly='true'		#设置cookie的httpOnly，基线为true，was8.X默认为true，WAS7及以下版本无该选择，可通过Web容器定制属性增加

#Web容器定制属性，可全部注释 
#WCPropertys= WCPropertys + [["com.ibm.ws.webcontainer.channelwritetype" , "sync"]]
#针对was6.1.0.43和was7.0.0.9以上版本设置cookie的httpOnly属性，也可针对应用程序自己的cookie设置，*可以指定为具体cookie名称，多个以英文逗号分隔
#WCPropertys= WCPropertys + [["com.ibm.ws.webcontainer.HTTPOnlyCookies" , "*"]]

#JVM，classpath如果存在多个，请使用英文;分号隔开
jvmClassPath = ""
jvmVerboseGC = "TRUE"			#详细垃圾回收，基线要求为TRUE
jvmInitHeapSize = "1024"		#默认为64，基线要求不小于512
jvmMaxHeapSize = "2048"		#默认为256，基线要求不小于1024
jvmGenericArguments = "-Djava.awt.headless=true -Xgcpolicy:gencon -Xmns512M"

#WAS日志配置，按日切割，每天生成一个日志文件
systemOutLogFile = "/log/WebSphere/AppServer/SystemOut.log"
systemErrLogFile = "/log/WebSphere/AppServer/SystemErr.log"
baseHour = "24"
historyFileCount = "30"		#日志个数保留，如果日志进行了gz等压缩，则该参数将不起作用
stdOutLogFile = "/log/WebSphere/AppServer/native_stdout.log"
stdErrLogFile = "/log/WebSphere/AppServer/native_stderr.log"

#server环境条目，可全部注释，以下四条请保留，如有更改请联系中间件组确认
JVMPropertys= JVMPropertys + [["IBM_HEAPDUMPDIR" , "/log/WebSphere/AppServer/dump"]]		#重定向heapdump生成目录
JVMPropertys= JVMPropertys + [["IBM_JAVACOREDIR" , "/log/WebSphere/AppServer/dump"]]		#重定向javacore生成目录
JVMPropertys= JVMPropertys + [["IBM_HEAPDUMP_OUTOFMEMORY" , "TRUE"]]
JVMPropertys= JVMPropertys + [["IBM_JAVADUMP_OUTOFMEMORY" , "TRUE"]]


#进程执行设置，如果was使用wasup用户启动，不需要修改
processPriorityValue = "20"
umaskValue = "022"
user = "appoper"
group = "hfgroup"

#默认jdbc提供者和默认应用（不需要修改，如果已经删除，脚本会跳过）
derbyJDBCProvider = "Derby JDBC Provider"
defaultApp1 = "DefaultApplication"
defaultApp2 = "ivtApp"
defaultApp3 = "query"

##############################  WAS Server 参数 ##############################


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

cellName=AdminControl.getCell()		#可以指定具体cellName
nodeName=AdminControl.getNode()		#可以指定具体nodeName

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
#获取WAS大版本号
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
