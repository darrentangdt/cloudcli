@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_ADMINGROUP.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                      
rem  功  能：检查Administrator组内的用户是否合规                                      
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_golbalpath="C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS"
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.获取Administrator组的用户信息
echo 原始信息>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
net localgroup Administrators>>%v_outpath%\SECAUD_WIN_ADMINGROUP_TMP.out
setlocal enabledelayedexpansion
set n=0
for /f "delims=" %%v in ('type %v_outpath%\SECAUD_WIN_ADMINGROUP_TMP.out') do (
set/a n=!n!+1
set v_row=%%v
if !n! GTR 2 (set v_row=!v_row:-=+!) else (set v_row=!v_row!)
echo !v_row! >>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
)
rem 2.截取文件第9行至倒数第2行的内容
set  v_num=0
for /f "delims=" %%i in ('type %v_outpath%\SECAUD_WIN_ADMINGROUP.out') do (
	set /a v_num=!v_num!+1
)
set v_startLine=6
set v_endLine=%v_num%
set /a v_number=%v_endLine%-%v_startLine%-1
call %v_golbalpath%\ReadLine %v_outpath%\SECAUD_WIN_ADMINGROUP.out %v_startLine% %v_number% >%v_outpath%\temp.out
rem 3.判断Administrators组内用户是否合规，仅可以包含1个或2个用户，若为2个用户，其中之一必为Patrol
for /f "delims=" %%i in ('type %v_outpath%\temp.out') do (
	set /a v_num2+=1
)

rem 4.Administrator组内用户数大于2，不合规
if %v_num2% GTR 2 (

	echo Administrator组内的用户过多，不合规。 >> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo Administrator组内的用户过多，不合规。 >> %v_outpath%\Conviction.out
)else (
	rem 5.判断是否为Administrator和Patrol用户，只有一个用户时为Administrator，两个用户时为Administrator和Patrol
	rem 若Administrator组内用户只有一个，不论是谁都认为合规。
	if %v_num2% EQU 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
		echo **********>>%v_outpath%"\SECAUD_WIN_ADMINGROUP.out
		echo Administrator组内的用户只包含一个用户，合规。>> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
	)
	if %v_num2% EQU 2 (
		findstr /n "Patrol" %v_outpath%\temp.out > %v_outpath%\temp1.out
		if errorlevel 1 (
			echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo 中间结论：>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo Administrator组内的用户除了1个用户外另一个用户不为Patrol，不合规。>> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo Administrator组内的用户除了1个用户外另一个用户不为Patrol，不合规。>> %v_outpath%\Conviction.out
		)
	)
)

rem 6.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
)

rem 7.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\SECAUD_WIN_ADMINGROUP_TMP.out del %v_outpath%\SECAUD_WIN_ADMINGROUP_TMP.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
