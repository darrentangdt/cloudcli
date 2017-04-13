@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_NETACC_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                          
rem  功  能：检查通过网络访问系统的用户信息                                        
rem ************************************************
@echo off
rem 检查临时脚本输出目录是否存在
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)


rem 1.检查通过网络访问系统的用户信息.
secedit /export /cfg %v_outpath%\temp.out >>%v_outpath%\temp1.out
echo **********>%v_outpath%\SECAUD_WIN_NETACC.out
echo 原始信息：>>%v_outpath%\SECAUD_WIN_NETACC.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
type %v_outpath%\temp.out|find "SeNetworkLogonRight" >>%v_outpath%\SECAUD_WIN_NETACC.out

rem 2.Everyone对应的系统里面的编号为”*S-1-1-0“
type %v_outpath%\SECAUD_WIN_NETACC.out|find "*S-1-1-0" >nul
if errorlevel 1 (
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 中间结果：>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 允许列表中不包含Everyone，合规。>>%v_outpath%\SECAUD_WIN_NETACC.out
)else (
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 中间结果：>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 允许列表中包含Everyone，不合规。>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 允许列表中包含Everyone，不合规。>>%v_outpath%\Conviction.out
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_NETACC.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_NETACC.out
)

rem 4.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 