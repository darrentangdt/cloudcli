set WAS_HOME=C:/IBM/WebSphere/AppServer
set ProfileName=AppSrv01
set ProfilePath=%WAS_HOME%/profiles/%ProfileName%
set CellName=hfcell
set NodeName=hfnode
set HostName=localhost
set ServerName=server1
set TemplatePath=%WAS_HOME%/profileTemplates/default
set UserName=was
set Password=Was123
echo Start to create profile $ProfileName
call %WAS_HOME%/bin/manageprofiles.bat -create -profileName %ProfileName% -profilePath %ProfilePath% -templatePath %TemplatePath% -nodeName %NodeName% -cellName %CellName% -hostName %HostName% -serverName %ServerName% -enableAdminSecurity true -adminUserName %UserName% -adminPassword %Password%

echo "finish"
PAUSE;
