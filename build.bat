SetLocal EnableDelayedExpansion
@ECHO OFF

echo Adding Path to tclsh.exe to PATH variable...
SET PATH=%PATH%;C:\ActiveTcl\bin\

SET SC_OUTPUT_DIR=C:\CppProjects\sqlcipher\
IF NOT DEFINED WINDOWSSDKDIR SET WINDOWSSDKDIR=C:\Program Files (x86)\Windows Kits\10\Include\10.0.16299.0
echo Windows SDK Directory set to: %WINDOWSSDKDIR%

IF /i "%PLATFORM%"=="x86" goto x86
IF /i "%PLATFORM%"=="x64" goto x64

echo Platform not supported: %PLATFORM%
goto commonExit

:x86
echo Platform: x86
SET OPENSSL_DIR=C:\OpenSSL-Win32

goto build

:x64
echo "Platform: x64"
SET OPENSSL_DIR=C:\OpenSSL-Win64

goto build

:build
echo Building configuration: DEBUG
nmake -f Makefile.msc clean
SET DEBUG=2
nmake -f Makefile.msc

goto commonExit

:commonExit

echo "Done."