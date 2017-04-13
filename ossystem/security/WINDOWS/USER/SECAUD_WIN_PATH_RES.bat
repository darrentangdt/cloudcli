@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_PATH_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                      
rem  功  能：检查PATH中是否有.                                    
rem ************************************************

rem 检查临时脚本输出目录是否存在 
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

@echo off
rem 1.获取PATH信息
echo 原始信息>%v_outpath%\SECAUD_WIN_PATH.out
echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
path>>%v_outpath%\SECAUD_WIN_PATH.out

rem 2.检查PATH中是否有.
find ";." %v_outpath%\SECAUD_WIN_PATH.out >%v_outpath%\temp.out
if errorlevel 1 (
	find ".;" %v_outpath%\SECAUD_WIN_PATH.out >%v_outpath%\temp.out
	if errorlevel 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_PATH.out
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo 检查PATH中不包含.，合规。>> %v_outpath%\SECAUD_WIN_PATH.out
	)else (
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_PATH.out
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo 检查PATH中包含.，不合规。>> %v_outpath%\SECAUD_WIN_PATH.out
		echo 检查PATH中包含.，不合规。>> %v_outpath%\Conviction.out
	)
)else (
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo 中间结论：>>%v_outpath%\SECAUD_WIN_PATH.out
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo 检查PATH中包含.，不合规。>> %v_outpath%\SECAUD_WIN_PATH.out
	echo 检查PATH中包含.，不合规。>> %v_outpath%\Conviction.out
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_PATH.out
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_PATH.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_PATH.out
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_PATH.out
)

rem 4.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 

