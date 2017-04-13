@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_SCREENPASS_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                               
rem  功  能：检查屏幕密码的设置                                              
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_golbalpath=C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.获取屏幕密码信息
echo 原始信息:>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo HKEY_CURRENT_USER\Control Panel\Desktop >>%v_outpath%\SECAUD_WIN_SCREENPASS.out
reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /s  2>nul|findstr ScreenSave >>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop >>%v_outpath%\SECAUD_WIN_SCREENPASS.out
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul | findstr ScreenSave >>%v_outpath%\SECAUD_WIN_SCREENPASS.out  

echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out


reg query "HKEY_CURRENT_USER\Control Panel\Desktop" /s  2>nul|findstr "ScreenSaveActive    REG_SZ     1">%v_outpath%\temp.out  
rem 2.获取有效信息
if errorlevel 1 (
	rem 3.注册表项不合规
	echo ScreenSaveActive注册表项不合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaveActive注册表项不合规 >> %v_outpath%\Conviction.out
) else (
	echo ScreenSaveActive注册表项合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)

reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul | findstr ScreenSave >%v_outpath%\temp.out  
rem 2.获取有效信息
if errorlevel 1 (
	rem 3.注册表项不合规
	echo ScreenSave注册表项不合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSave注册表项不合规 >> %v_outpath%\Conviction.out
) else (
	echo ScreenSave注册表项合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)

reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul |findstr "ScreenSaverIsSecure    REG_SZ    1" > %v_outpath%\temp.out
rem 3.获取有效信息
if errorlevel 1 (
	rem 3.注册表项不合规
	echo ScreenSaverIsSecure注册表项不合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaverIsSecure注册表项不合规 >> %v_outpath%\Conviction.out
) else (
	echo ScreenSaverIsSecure注册表项合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)


rem 4.获取有效信息
reg query "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /s 2>nul | findstr ScreenSaveTimeOut >%v_outpath%\temp1.out  
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_SCREENPASS_ScreenSaveTimeOut "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_ScreenSaveTimeOut_value=%%i 
for /f "delims=" %%a in ('type %v_outpath%\temp1.out') do (for %%i in (%%a) do (echo %%i >>%v_outpath%\temp2.out))
for /f %%b in ('type %v_outpath%\temp2.out') do set v_ScreenSaveTimeOut=%%b
type %v_outpath%\temp1.out|find "ScreenSaveTime" > %v_outpath%\temp.out
if errorlevel 0 (
	for /f "tokens=2 delims=" %%a in ('findstr ScreenSaveTimeOut %v_outpath%\temp1.out') do set v_ScreenSaveTimeOut=%%a
		if  %v_ScreenSaveTimeOut% LEQ %v_ScreenSaveTimeOut_value% (
	  echo ScreenSaveTimeOut注册表项合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
    )else (
	  echo ScreenSaveTimeOut注册表项不合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	  echo ScreenSaveTimeOut注册表项不合规 >> %v_outpath%\Conviction.out
    )
)else (
	echo ScreenSaveTimeOut注册表项不合规 >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo ScreenSaveTimeOut注册表项不合规 >> %v_outpath%\Conviction.out
)


rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SCREENPASS.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_SCREENPASS.out
)

rem 4.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\temp3.out del %v_outpath%\temp3.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 