@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_NETBIOS_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                        
rem  ��  �ܣ����NETBIOS�Ƿ�ر�                                     
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

@echo off
rem 1.��ȡNETBIOS�����Ϣ��
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_NETBIOS.out
echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
ipconfig /all >>%v_outpath%\temp.out

rem 2.��ȡ�����Ϣ
type %v_outpath%\temp.out|find "TCPIP �ϵ� NetBIOS">>%v_outpath%\SECAUD_WIN_NETBIOS.out

rem 3.����Ƿ�Ϲ�
echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_NETBIOS.out
echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
type %v_outpath%\SECAUD_WIN_NETBIOS.out|find "������" >>%v_outpath%\temp.out
if errorlevel 1 (
	echo NETBIOS�ر�,�Ϲ�.>>%v_outpath%\SECAUD_WIN_NETBIOS.out
)else (
	echo NETBIOSδ�رգ����Ϲ�.>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo NETBIOSδ�رգ����Ϲ�.>%v_outpath%\Conviction.out
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_NETBIOS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETBIOS.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_NETBIOS.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
