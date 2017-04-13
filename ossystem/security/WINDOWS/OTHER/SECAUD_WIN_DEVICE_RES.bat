@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_DEVICE_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                       
rem  ��  �ܣ�����豸��ص�������                                               
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_golbalpath=C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡ�豸��Ϣ.
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_DEVICE.out
echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
secedit /export /cfg %v_outpath%\SECAUD_WIN_DEVICE.out >%v_outpath%\temp1.out

setlocal enabledelayedexpansion

echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_DEVICE.out
echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out

rem -----AllocateFloppies-----
set "flag=0"
type %v_outpath%\SECAUD_WIN_DEVICE.out|find "MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateFloppies" >%v_outpath%\temp.out
rem 2.��ȡ�����Ϣ.
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo AllocateFloppiesע�������ڡ����Ϲ� >> %v_outpath%\SECAUD_WIN_DEVICE.out
	echo AllocateFloppiesע�������ڡ����Ϲ� >> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע������ֵ���Ϲ�.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
		call set "var=%%var:~1,1%%"
	)
	rem 4.���ַ���ת��Ϊ����.
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !number! NEQ 1 (
		echo AllocateFloppies��ֵ���ò��Ϲ�. >> %v_outpath%\SECAUD_WIN_DEVICE.out
		echo AllocateFloppies��ֵ���ò��Ϲ�. >> %v_outpath%\Conviction.out
	) else (
		echo AllocateFloppies��ֵ���úϹ�. >> %v_outpath%\SECAUD_WIN_DEVICE.out
	)
)

rem -----AllocateDASD-----
set "flag=0"
type %v_outpath%\SECAUD_WIN_DEVICE.out|find "MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateDASD" > %v_outpath%\temp.out
rem 2.Get Useful Information.
if errorlevel 1 (
	rem 3.Case 1. Didn't find the value,Conviction.
	echo AllocateDASDע�������ڡ����Ϲ� >> %v_outpath%\SECAUD_WIN_DEVICE.out
	echo AllocateDASDע�������ڡ����Ϲ� >> %v_outpath%\Conviction.out
) else (
	rem 3.Case 2.The value is not Complicance.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
		call set "var=%%var:~1,1%%"
	)
	rem 4.Chang String into Number
	set /a number=!var!+0
	set "flag=1"
)
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_DEVICE_AllocateDASD "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_AllocateDASD_value=%%i 
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !number! NEQ %v_AllocateDASD_value% (
		echo AllocateDASD��ֵ���ò��Ϲ�. >> %v_outpath%\SECAUD_WIN_DEVICE.out
		echo AllocateDASD��ֵ���ò��Ϲ�. >> %v_outpath%\Conviction.out
	) else (
		echo AllocateDASD��ֵ���úϹ�. >> %v_outpath%\SECAUD_WIN_DEVICE.out
	)
)

rem -----ShutdownWithoutLogon-----
set "flag=0"
type %v_outpath%\SECAUD_WIN_DEVICE.out|find "MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon" >%v_outpath%\temp.out
rem 2.Get Useful Information.
if errorlevel 1 (
	rem 3.Case 1. Didn't find the value,Conviction.
	echo ShutdownWithoutLogonע�������ڡ����Ϲ� >> %v_outpath%\SECAUD_WIN_DEVICE.out
	echo ShutdownWithoutLogonע�������ڡ����Ϲ� >> %v_outpath%\Conviction.out
) else (
	rem 3.Case 2.The value is not Complicance.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
		call set "var=%%var:~0%%"
	)
	rem 4.Chang String into Number
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !number! NEQ 0 (
		echo ShutdownWithoutLogon��ֵ���ò��Ϲ�. >> %v_outpath%\SECAUD_WIN_DEVICE.out
		echo ShutdownWithoutLogon��ֵ���ò��Ϲ�. >> %v_outpath%\Conviction.out
	) else (
		echo ShutdownWithoutLogon��ֵ���úϹ�. >> %v_outpath%\SECAUD_WIN_DEVICE.out
	)
)

rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_DEVICE.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_DEVICE.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 