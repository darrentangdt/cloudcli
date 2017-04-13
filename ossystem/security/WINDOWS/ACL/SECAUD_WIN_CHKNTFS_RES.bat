@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_CHKNTFS_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日  
rem  功  能：检查各卷是否为NTFS格式                                      
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
rem 1.获取所有卷组信息，依次判断是否为NTFS。
echo 原始信息:>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo 所有卷:>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
fsutil fsinfo drives >%v_outpath%\temp.out
fsutil fsinfo drives >>%v_outpath%\SECAUD_WIN_CHKNTFS.out

rem 2.进行格式转换 
for /f "delims=" %%a in ('type %v_outpath%\temp.out') do (
    for %%i in (%%a) do (
        echo %%i>>%v_outpath%\temp2.out
    )
)

setlocal EnableDelayedExpansion
rem 3.依次检查各卷的文件格式.
echo 其中固定驱动器如下:>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
for /f "skip=1 delims=" %%i in ('type %v_outpath%\temp2.out ') do (
	set var=%%i
	call set "v_juan=%%var%%"
	fsutil fsinfo drivetype !v_juan!>%v_outpath%\temp3.out
	rem 4.判断是否为固定驱动器 
	type %v_outpath%\temp3.out|find "固定驱动器" >%v_outpath%\temp6.out
	if errorlevel 1 (
		echo nothing>%v_outpath%\temp3.out
	)else (
		echo !v_juan!>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
		echo !v_juan!>>%v_outpath%\temp4.out
	)
)

echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
if exist %v_outpath%\temp4.out (
	for /f "delims=" %%i in ('type %v_outpath%\temp4.out') do (
		fsutil fsinfo ntfsinfo %%i > %v_outpath%\temp5.out
		type %v_outpath%\temp5.out|find "NTFS 卷序列号" > %v_outpath%\temp6.out
		if errorlevel 1 (
			echo %%i 卷不是NTFS格式，不合规>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
			echo %%i 卷不是NTFS格式，不合规>%v_outpath%\Conviction.out
		)else (
			echo %%i 卷是NTFS格式，合规>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
		)
	)
)else (
	echo 无固定驱动器，合规>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
)


rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_CHKNTFS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_CHKNTFS.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\temp3.out del %v_outpath%\temp3.out
if exist %v_outpath%\temp4.out del %v_outpath%\temp4.out
if exist %v_outpath%\temp5.out del %v_outpath%\temp5.out
if exist %v_outpath%\temp6.out del %v_outpath%\temp6.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out