@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_SCREENPASS_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                               
rem  ��  �ܣ������Ļ���������                                              
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

rem 1.��ȡ��Ļ������Ϣ
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo HKEY_CURRENT_USER\Control Panel\Desktop >>%v_outpath%\SECAUD_WIN_SCREENPASS.out
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /s  2>nul|findstr ScreenSave >>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop >>%v_outpath%\SECAUD_WIN_SCREENPASS.out
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul | findstr ScreenSave >>%v_outpath%\SECAUD_WIN_SCREENPASS.out  

echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out


reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /s  2>nul|findstr "ScreenSaveActive    REG_SZ     1">%v_outpath%\temp.out  
rem 2.��ȡ��Ч��Ϣ
if errorlevel 1 (
	rem 3.ע�����Ϲ�
	echo ScreenSaveActiveע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaveActiveע�����Ϲ� >> %v_outpath%\Conviction.out
) else (
	echo ScreenSaveActiveע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)

reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul | findstr ScreenSave >%v_outpath%\temp.out  
rem 2.��ȡ��Ч��Ϣ
if errorlevel 1 (
	rem 3.ע�����Ϲ�
	echo ScreenSaveע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaveע�����Ϲ� >> %v_outpath%\Conviction.out
) else (
	echo ScreenSaveע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)

reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul |findstr "ScreenSaverIsSecure    REG_SZ    1" > %v_outpath%\temp.out
rem 3.��ȡ��Ч��Ϣ
if errorlevel 1 (
	rem 3.ע�����Ϲ�
	echo ScreenSaverIsSecureע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaverIsSecureע�����Ϲ� >> %v_outpath%\Conviction.out
) else (
	echo ScreenSaverIsSecureע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)


rem 4.��ȡ��Ч��Ϣ
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul | findstr ScreenSaveTimeOut >%v_outpath%\temp1.out  
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_SCREENPASS_ScreenSaveTimeOut "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_ScreenSaveTimeOut_value=%%i 
for /f "delims=" %%a in ('type %v_outpath%\temp1.out') do (for %%i in (%%a) do (echo %%i >>%v_outpath%\temp2.out))
for /f %%b in ('type %v_outpath%\temp2.out') do set v_ScreenSaveTimeOut=%%b
type %v_outpath%\temp1.out|find "ScreenSaveTime" > %v_outpath%\temp.out
if errorlevel 0 (
	for /f "tokens=2 delims=" %%a in ('findstr ScreenSaveTimeOut %v_outpath%\temp1.out') do set v_ScreenSaveTimeOut=%%a
		if  %v_ScreenSaveTimeOut% LEQ %v_ScreenSaveTimeOut_value% (
	  echo ScreenSaveTimeOutע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
    )else (
	  echo ScreenSaveTimeOutע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	  echo ScreenSaveTimeOutע�����Ϲ� >> %v_outpath%\Conviction.out
    )
)else (
	echo ScreenSaveTimeOutע�����Ϲ� >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaveTimeOutע�����Ϲ� >> %v_outpath%\Conviction.out
)


rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)

rem 4.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\temp3.out del %v_outpath%\temp3.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 