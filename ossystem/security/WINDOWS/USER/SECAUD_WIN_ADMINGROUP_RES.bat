@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_ADMINGROUP.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                      
rem  ��  �ܣ����Administrator���ڵ��û��Ƿ�Ϲ�                                      
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_golbalpath="C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS"
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡAdministrator����û���Ϣ
echo ԭʼ��Ϣ>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
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
rem 2.��ȡ�ļ���9����������2�е�����
set  v_num=0
for /f "delims=" %%i in ('type %v_outpath%\SECAUD_WIN_ADMINGROUP.out') do (
	set /a v_num=!v_num!+1
)
set v_startLine=6
set v_endLine=%v_num%
set /a v_number=%v_endLine%-%v_startLine%-1
call %v_golbalpath%\ReadLine %v_outpath%\SECAUD_WIN_ADMINGROUP.out %v_startLine% %v_number% >%v_outpath%\temp.out
rem 3.�ж�Administrators�����û��Ƿ�Ϲ棬�����԰���1����2���û�����Ϊ2���û�������֮һ��ΪPatrol
for /f "delims=" %%i in ('type %v_outpath%\temp.out') do (
	set /a v_num2+=1
)

rem 4.Administrator�����û�������2�����Ϲ�
if %v_num2% GTR 2 (

	echo Administrator���ڵ��û����࣬���Ϲ档 >> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo Administrator���ڵ��û����࣬���Ϲ档 >> %v_outpath%\Conviction.out
)else (
	rem 5.�ж��Ƿ�ΪAdministrator��Patrol�û���ֻ��һ���û�ʱΪAdministrator�������û�ʱΪAdministrator��Patrol
	rem ��Administrator�����û�ֻ��һ����������˭����Ϊ�Ϲ档
	if %v_num2% EQU 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
		echo **********>>%v_outpath%"\SECAUD_WIN_ADMINGROUP.out
		echo Administrator���ڵ��û�ֻ����һ���û����Ϲ档>> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
	)
	if %v_num2% EQU 2 (
		findstr /n "Patrol" %v_outpath%\temp.out > %v_outpath%\temp1.out
		if errorlevel 1 (
			echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo Administrator���ڵ��û�����1���û�����һ���û���ΪPatrol�����Ϲ档>> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
			echo Administrator���ڵ��û�����1���û�����һ���û���ΪPatrol�����Ϲ档>> %v_outpath%\Conviction.out
		)
	)
)

rem 6.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo **********>>%v_outpath%\SECAUD_WIN_ADMINGROUP.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_ADMINGROUP.out
)

rem 7.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\SECAUD_WIN_ADMINGROUP_TMP.out del %v_outpath%\SECAUD_WIN_ADMINGROUP_TMP.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
