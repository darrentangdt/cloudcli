@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_AUTORUN_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                           
rem  ��  �ܣ�����Զ����е�����                                              
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

rem 1.��ȡ�Զ����е���Ϣ.
echo ԭʼ��Ϣ:  >%v_outpath%\SECAUD_WIN_AUTORUN.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /s >>%v_outpath%\SECAUD_WIN_AUTORUN.out
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /s |findstr NoDriveTypeAutoRun  >>%v_outpath%\temp1.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_AUTORUN.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_AUTORUN_NoDriveTypeAutoRun "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_NoDriveTypeAutoRun_value=%%i
for /f "delims=" %%a in ('type %v_outpath%\temp1.out') do (for %%i in (%%a) do (echo %%i >>%v_outpath%\temp2.out))
for /f %%b in ('type %v_outpath%\temp2.out') do set v_ScreenSaveTimeOut=%%b
echo %v_NoDriveTypeAutoRun_value% | findstr %v_ScreenSaveTimeOut% 2>nul 1>nul
rem 2.��ȡ��Ч��Ϣ
if errorlevel 1 (
	rem 3.ע�����Ϲ�
	echo NoDriveTypeAutoRunע�����Ϲ� >> %v_outpath%\SECAUD_WIN_AUTORUN.out
	echo NoDriveTypeAutoRunע�����Ϲ� >> %v_outpath%\Conviction.out
) else (
	echo NoDriveTypeAutoRunע�����Ϲ� >> %v_outpath%\SECAUD_WIN_AUTORUN.out
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_AUTORUN.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_AUTORUN.out
)

rem 4.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp.out del %v_outpath%\temp2.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 