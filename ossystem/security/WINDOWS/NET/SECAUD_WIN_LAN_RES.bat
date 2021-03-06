@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_LAN_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                          
rem  功  能：检查LAN Manager的身份验证级别                                              
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

rem 1.获取LAN MANAGER的身份验证级别。
echo 原始信息:>%v_outpath%\SECAUD_WIN_LAN.out
echo **********>>%v_outpath%\SECAUD_WIN_LAN.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out

setlocal enabledelayedexpansion

rem 2.检查LAN Manager的身份验证级别
set "flag=0"
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\LmCompatibilityLevel" >>%v_outpath%\SECAUD_WIN_LAN.out 2>&1
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo LmCompatibilityLevel不存在。不合规>> %v_outpath%\SECAUD_WIN_LAN.out
	echo LmCompatibilityLevel不存在。不合规>%v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表的值设置不合规.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\SECAUD_WIN_LAN.out') do (
		set "var=%%i"
	)
	rem 4.将字符串转换为数字.
	set /a v_number=!var!+0
	set "flag=1"
)
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_LAN_LmCompatibilityLevel "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_LmCompatibilityLevel_value=%%i 
if %flag%==1 (
	rem 5.检查是否合规.
	if !v_number! NEQ %v_LmCompatibilityLevel_value% (
		echo LmCompatibilityLevel的值设置不合规.>> %v_outpath%\SECAUD_WIN_LAN.out
		echo LmCompatibilityLevel的值设置不合规.>%v_outpath%\Conviction.out
	)else (
		echo LmCompatibilityLevel的值设置合规.>> %v_outpath%\SECAUD_WIN_LAN.out
	)
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_LAN.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_LAN.out
	echo **********>>%v_outpath%\SECAUD_WIN_LAN.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_LAN.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_LAN.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_LAN.out
	echo **********>>%v_outpath%\SECAUD_WIN_LAN.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_LAN.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 