@echo off&SetLocal ENABLEDELAYEDEXPANSION

set file=%~s1
set first="skip=%2 delims=: tokens=1*"
set last=%3
set loop=0
for /f %first% %%a in ('findstr/n .* %file%') do (
        if not defined lxmxn (echo/%%b&set /a loop+=1) else (goto :EOF)
        if "!loop!"=="%last%" set lxmxn=Nothing
)
GOTO :EOF

:--help
echo/======================================
echo/���������Ҫ������������������
echo/&echo/Usage:&echo/Call ReadLine ^<�ļ���^> ^<��������^> ^<��ȡ����^>
echo/&echo/���磺call ReadLine aa.txt 5 7 ��������aa.txt�ļ���ǰ5�У���ȡ�����7���ַ�
echo/&echo/���^<��������^>û��ָ�����ʹ��ļ���һ�ж�ȡ
echo/&echo/ָ��^<��ȡ����^>ʱ����ָ��^<������^>
echo/======================================
goto :eof