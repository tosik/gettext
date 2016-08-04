@echo off
setlocal

if "%1"=="clean" goto :clean
if "%1"=="noclean" (
	set __NOCLEAN__=true
	shift)

nuget install packages.config

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
call :build Win32 Release v140
call :build Win32 Debug v140
call :build x64 Release v140
call :build x64 Debug v140
endlocal

setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
call :build Win32 Release v120
call :build Win32 Debug v120
call :build x64 Release v120
call :build x64 Debug v120
endlocal

goto :eof

:build
msbuild /P:Platform=%1 /P:Configuration=%2 /P:PlatformToolset=%3 /P:UsesConfigurationType=Dynamic libintl.vcxproj
goto :eof

