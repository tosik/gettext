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

cd ..
call :test Win32 Release v140
call :test Win32 Debug v140
call :test x64 Release v140
call :test x64 Debug v140
call :test Win32 Release v120
call :test Win32 Debug v120
call :test x64 Release v120
call :test x64 Debug v120
cd COPKG

if "__NOCLEAN__"=="true" goto :eof

goto :clean

:build
msbuild /P:Platform=%1 /P:Configuration=%2 /P:PlatformToolset=%3 libintl.vcxproj
goto :eof

:failed
set __FAILED__=true
echo tests failed for %1 %2 %3
goto :eof

:clean
rd /s /q ..\projects\vstudio\libpng\v120
rd /s /q ..\projects\vstudio\pnglibconf\v120
rd /s /q ..\projects\vstudio\pngtest\v120
rd /s /q ..\projects\vstudio\pngvalid\v120
rd /s /q ..\projects\vstudio\libpng\v140
rd /s /q ..\projects\vstudio\pnglibconf\v140
rd /s /q ..\projects\vstudio\pngtest\v140
rd /s /q ..\projects\vstudio\pngvalid\v140

