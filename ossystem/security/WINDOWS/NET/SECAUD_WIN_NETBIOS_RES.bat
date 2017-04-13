@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_NETBIOS_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                        
rem  功  能：检查NETBIOS是否关闭                                     
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

@echo off
rem 1.获取NETBIOS相关信息。
echo 原始信息:>%v_outpath%\SECAUD_WIN_NETBIOS.out
echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
ipconfig /all >>%v_outpath%\temp.out

rem 2.获取相关信息
type %v_outpath%\temp.out|find "TCPIP 上的 NetBIOS">>%v_outpath%\SECAUD_WIN_NETBIOS.out

rem 3.检查是否合规
echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_NETBIOS.out
echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
type %v_outpath%\SECAUD_WIN_NETBIOS.out|find "已启用" >>%v_outpath%\temp.out
if errorlevel 1 (
	echo NETBIOS关闭,合规.>>%v_outpath%\SECAUD_WIN_NETBIOS.out
)else (
	echo NETBIOS未关闭，不合规.>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo NETBIOS未关闭，不合规.>%v_outpath%\Conviction.out
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_NETBIOS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_NETBIOS.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
