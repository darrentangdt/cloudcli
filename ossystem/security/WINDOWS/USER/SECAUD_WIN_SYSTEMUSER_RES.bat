@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_SYSTEMUSER_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                         
rem  ��  �ܣ�������ϵͳ�û�(�˹�)                                             
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)
rem �����ʷ��ѯ��¼�Ƿ����
if exist %v_outpath%\SECAUD_WIN_SYSTEMUSER.out del %v_outpath%\SECAUD_WIN_SYSTEMUSER.out
rem 1.��ȡϵͳ�û���Ϣ.
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