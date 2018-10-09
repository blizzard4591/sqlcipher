SetLocal EnableDelayedExpansion
@ECHO OFF

echo Adding Path to tclsh.exe to PATH variable...
SET PATH=%PATH%;C:\ActiveTcl\bin\

SET SC_OUTPUT_DIR=C:\CppProjects\sqlcipher
IF NOT DEFINED WINDOWSSDKDIR SET WINDOWSSDKDIR=C:\Program Files (x86)\Windows Kits\10\Include\10.0.16299.0
IF %WINDOWSSDKDIR:~-1%==\ SET WINDOWSSDKDIR=%WINDOWSSDKDIR:~0,-1%
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
@mkdir "%SC_OUTPUT_DIR%\include"
@mkdir "%SC_OUTPUT_DIR%\include\sqlcipher"
@mkdir "%SC_OUTPUT_DIR%\compile"
@mkdir "%SC_OUTPUT_DIR%\compile\%PLATFORM%"
@mkdir "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Debug"
@mkdir "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Release"
@mkdir "%SC_OUTPUT_DIR%\distribute"
@mkdir "%SC_OUTPUT_DIR%\distribute\%PLATFORM%"
@mkdir "%SC_OUTPUT_DIR%\distribute\%PLATFORM%\Debug"
@mkdir "%SC_OUTPUT_DIR%\distribute\%PLATFORM%\Release"

echo Building configuration: DEBUG %PLATFORM%
nmake -f Makefile.msc clean > buildLogDebug.txt 2>&1
SET DEBUG=2
nmake -f Makefile.msc >> buildLogDebug.txt 2>&1
IF ERRORLEVEL 1 GOTO errorHandling
lib /NOLOGO /MACHINE:%PLATFORM% /def:sqlite3.def /out:"%SC_OUTPUT_DIR%\compile\%PLATFORM%\Debug\sqlite3.lib"

xcopy /Y sqlite3.dll "%SC_OUTPUT_DIR%\distribute\%PLATFORM%\Debug\"
xcopy /Y sqlite3.dll "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Debug\"
REM xcopy /Y sqlite3.lib "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Debug\"
xcopy /Y sqlite3.pdb "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Debug\"

echo Building configuration: RELEASE %PLATFORM%
nmake -f Makefile.msc clean > buildLogRelease.txt 2>&1
SET DEBUG=0
nmake -f Makefile.msc >> buildLogRelease.txt 2>&1
IF ERRORLEVEL 1 GOTO errorHandling
lib /NOLOGO /MACHINE:%PLATFORM% /def:sqlite3.def /out:"%SC_OUTPUT_DIR%\compile\%PLATFORM%\Release\sqlite3.lib"
xcopy /Y sqlite3.dll "%SC_OUTPUT_DIR%\distribute\%PLATFORM%\Release\"
xcopy /Y sqlite3.dll "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Release\"
REM xcopy /Y sqlite3.lib "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Release\"
xcopy /Y sqlite3.pdb "%SC_OUTPUT_DIR%\compile\%PLATFORM%\Release\"

xcopy /Y sqlite3.h "%SC_OUTPUT_DIR%\include\sqlcipher\"

goto commonExit

:errorHandling
echo Could not compile, please verify that you entered correct paths for tclsh.exe and OpenSSL at the top of build.bat!
echo More information can be found in the build log files called buildLogRelease.txt and buildLogDebug.txt
echo ********** BUILD FAILURE **********
exit /b 1

:commonExit

echo "Done."