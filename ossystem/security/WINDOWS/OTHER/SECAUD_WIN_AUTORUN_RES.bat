@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_AUTORUN_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                           
rem  功  能：检查自动运行的设置                                              
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

rem 1.获取自动运行的信息.
echo 原始信息:  >%v_outpath%\SECAUD_WIN_AUTORUN.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /s >>%v_outpath%\SECAUD_WIN_AUTORUN.out
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /s |findstr NoDriveTypeAutoRun  >>%v_outpath%\temp1.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_AUTORUN.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_AUTORUN_NoDriveTypeAutoRun "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_NoDriveTypeAutoRun_value=%%i
for /f "delims=" %%a in ('type %v_outpath%\temp1.out') do (for %%i in (%%a) do (echo %%i >>%v_outpath%\temp2.out))
for /f %%b in ('type %v_outpath%\temp2.out') do set v_ScreenSaveTimeOut=%%b
echo %v_NoDriveTypeAutoRun_value% | findstr %v_ScreenSaveTimeOut% 2>nul 1>nul
rem 2.获取有效信息
if errorlevel 1 (
	rem 3.注册表项不合规
	echo NoDriveTypeAutoRun注册表项不合规 >> %v_outpath%\SECAUD_WIN_AUTORUN.out
	echo NoDriveTypeAutoRun注册表项不合规 >> %v_outpath%\Conviction.out
) else (
	echo NoDriveTypeAutoRun注册表项合规 >> %v_outpath%\SECAUD_WIN_AUTORUN.out
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_AUTORUN.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTORUN.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_AUTORUN.out
)

rem 4.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp.out del %v_outpath%\temp2.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 