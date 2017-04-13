@echo off
set curDir=%cd%


set IM_Repository=%curDir%\IM
set IM_HOME="C:\IBM\Installation Manager\eclipse"
set WAS_Repository=http://55.3.15.145/repository
set IMShared_HOME=C:\IBM\IMShared
set WAS_HOME=C:\IBM\WebSphere\AppServer

echo "*********************************************************************"
echo "*	Step 1/4: create silent File...					*"
echo "********************************************************************"

rem �滻IM�ı�
cd %curDir%/response
call :replacdString   #IM_Repository#    %IM_Repository%    installIM.templete     installIM.xml.tmp
del installIM.xml
rename installIM.xml.tmp installIM.xml

call :replacdString   #IM_HOME#    %IM_HOME%   installIM.xml     installIM.xml.tmp
del installIM.xml
rename installIM.xml.tmp installIM.xml

rem �滻WAS�ı�
cd %curDir%/response
call :replacdString   #WAS_Repository#    %WAS_Repository%    installWAS.templete     installWAS.xml.tmp
del installWAS.xml
rename installWAS.xml.tmp installWAS.xml
call :replacdString   #IMShared_HOME#    %IMShared_HOME%    installWAS.xml     installWAS.xml.tmp
del installWAS.xml
rename installWAS.xml.tmp installWAS.xml
call :replacdString   #WAS_HOME#    %WAS_HOME%    installWAS.xml     installWAS.xml.tmp
del installWAS.xml
rename installWAS.xml.tmp installWAS.xml

echo ""
echo "*****************************************************************************"
echo "*	Step 2/4: install IM  begin .....*"
echo "*****************************************************************************"

rem ��װIBM
cd %curDir%/IM
userinstc -input %curDir%/response/installIM.xml -silent -showProgress -acceptLicense

echo "*****************************************************************************"
echo "*	Step 3/4: install WAS  begin .....*"
echo "*****************************************************************************"

cd %IM_HOME%/tools
imcl -input %curDir%/response/installWAS.xml -silent -showProgress -acceptLicense



echo "*****************************************************************************"
echo "*	Step 4/4: create Profile .....*"
echo "*****************************************************************************"
cd %curDir%
call createProfile.bat


echo "*****************************************************************************"
echo "*	Finish...*"
echo "*****************************************************************************"
pause



rem �滻�ļ����ַ�����Ȼ�󱣴�Ϊ���ļ�
rem ����1:��Ҫ�滻���ַ���
rem ����2��Ŀ���ַ���
rem ����3:�ļ�����
rem ����4��Ŀ���ļ�����
:replacdString
	setlocal enabledelayedexpansion
	cd .>%4
	for /f "tokens=*" %%a in (%3) do (
	    set var=%%a
	    set change=!var:%1=%2!
	    echo !change! >> %4
	)
