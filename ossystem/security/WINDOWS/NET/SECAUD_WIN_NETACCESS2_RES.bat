@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_NETACCESS_RES2.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                         
rem  ��  �ܣ����������ʵ����ã��˹���                                            
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_golbalpath=C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡ���������Ϣ.
echo Log
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_NETACCESS2.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS2.out
secedit /export /cfg %v_outpath%\temp.out  2>nul 1>nul

type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\SecurePipeServers\Winreg\AllowedExactPaths\Machine" >> %v_outpath%\SECAUD_WIN_NETACCESS2.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\RestrictNullSessAccess" >> %v_outpath%\SECAUD_WIN_NETACCESS2.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Services\LanManServer\Parameters\NullSessionShares" >> %v_outpath%\SECAUD_WIN_NETACCESS2.out


if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
