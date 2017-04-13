@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_CHKNTFS_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��  
rem  ��  �ܣ��������Ƿ�ΪNTFS��ʽ                                      
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

@echo off
rem 1.��ȡ���о�����Ϣ�������ж��Ƿ�ΪNTFS��
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo ���о�:>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
fsutil fsinfo drives >%v_outpath%\temp.out
fsutil fsinfo drives >>%v_outpath%\SECAUD_WIN_CHKNTFS.out

rem 2.���и�ʽת�� 
for /f "delims=" %%a in ('type %v_outpath%\temp.out') do (
    for %%i in (%%a) do (
        echo %%i>>%v_outpath%\temp2.out
    )
)

setlocal EnableDelayedExpansion
rem 3.���μ�������ļ���ʽ.
echo ���й̶�����������:>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
for /f "skip=1 delims=" %%i in ('type %v_outpath%\temp2.out ') do (
	set var=%%i
	call set "v_juan=%%var%%"
	fsutil fsinfo drivetype !v_juan!>%v_outpath%\temp3.out
	rem 4.�ж��Ƿ�Ϊ�̶������� 
	type %v_outpath%\temp3.out|find "�̶�������" >%v_outpath%\temp6.out
	if errorlevel 1 (
		echo nothing>%v_outpath%\temp3.out
	)else (
		echo !v_juan!>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
		echo !v_juan!>>%v_outpath%\temp4.out
	)
)

echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
if exist %v_outpath%\temp4.out (
	for /f "delims=" %%i in ('type %v_outpath%\temp4.out') do (
		fsutil fsinfo ntfsinfo %%i > %v_outpath%\temp5.out
		type %v_outpath%\temp5.out|find "NTFS �����к�" > %v_outpath%\temp6.out
		if errorlevel 1 (
			echo %%i ����NTFS��ʽ�����Ϲ�>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
			echo %%i ����NTFS��ʽ�����Ϲ�>%v_outpath%\Conviction.out
		)else (
			echo %%i ����NTFS��ʽ���Ϲ�>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
		)
	)
)else (
	echo �޹̶����������Ϲ�>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
)


rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_CHKNTFS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHKNTFS.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_CHKNTFS.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\temp3.out del %v_outpath%\temp3.out
if exist %v_outpath%\temp4.out del %v_outpath%\temp4.out
if exist %v_outpath%\temp5.out del %v_outpath%\temp5.out
if exist %v_outpath%\temp6.out del %v_outpath%\temp6.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out