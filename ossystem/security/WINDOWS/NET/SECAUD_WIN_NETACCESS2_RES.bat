@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_NETACCESS_RES2.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                         
rem  功  能：检查网络访问的设置（人工）                                            
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

rem 1.获取网络访问信息.
echo Log
echo 原始信息:>%v_outpath%\SECAUD_WIN_NETACCESS2.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS2.out
secedit /export /cfg %v_outpath%\temp.out  2>nul 1>nul

type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths\Machine" >> %v_outpath%\SECAUD_WIN_NETACCESS2.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\RestrictNullSessAccess" >> %v_outpath%\SECAUD_WIN_NETACCESS2.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionShares" >> %v_outpath%\SECAUD_WIN_NETACCESS2.out


if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
