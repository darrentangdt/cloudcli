@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_PASSEXPIRE_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                        
rem  功  能：检查密码到期提示是否开启                                      
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

rem 1.获取密码到期提示信息
echo 原始信息>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out

rem 2.检查密码到期提示是否开启.
type %v_outpath%\temp.out|find "PasswordExpiryWarning=" >%v_outpath%\temp1.out
type %v_outpath%\temp.out|find "PasswordExpiryWarning=" >>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
rem 2.过滤信息，去除空格.
for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp1.out') do (
	set "var=%%i"
)
rem 3.将字符串转换为数字
set /a v_number=%var%+0
rem 4.进行合规性比对
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSEXPIRE_PasswordExpiryWarning "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_PasswordExpiryWarning_value=%%i 
if %v_number% LSS %v_PasswordExpiryWarning_value% (
	echo PasswordExpiryWarning小于%v_PasswordExpiryWarning_value%，不合规.>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo PasswordExpiryWarning小于%v_PasswordExpiryWarning_value%，不合规.>>%v_outpath%\Conviction.out
) else (
	echo PasswordExpiryWarning为%v_number%，合规.>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
)

rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_PASSEXPIRE.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_PASSEXPIRE.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 