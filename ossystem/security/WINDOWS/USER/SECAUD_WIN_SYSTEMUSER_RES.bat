@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_SYSTEMUSER_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                         
rem  功  能：检查操作系统用户(人工)                                             
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)
rem 检查历史查询记录是否存在
if exist %v_outpath%\SECAUD_WIN_SYSTEMUSER.out del %v_outpath%\SECAUD_WIN_SYSTEMUSER.out
rem 1.获取系统用户信息.
echo Log
net user>%v_outpath%\SECAUD_WIN_SYSTEMUSER_TMP.out
setlocal enabledelayedexpansion
set n=0
for /f "delims=" %%v in ('type %v_outpath%\SECAUD_WIN_SYSTEMUSER_TMP.out') do (
set/a n=!n!+1
set v_row=%%v
if !n! EQU 2 (set v_row=!v_row:-=+!) else (set v_row=!v_row!)
echo !v_row! >>%v_outpath%\SECAUD_WIN_SYSTEMUSER.out
)
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\SECAUD_WIN_SYSTEMUSER_TMP.out del %v_outpath%\SECAUD_WIN_SYSTEMUSER_TMP.out