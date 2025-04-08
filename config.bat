@echo off
set server=10.0.0.10
set mand=300
set usr=usuario
set pwd=contrasena
set directorio=C:\InterfaceODOO\ENTRADA
set logPath=%directorio%\logs
set duplicatePath=%directorio%\duplicados
set today=%date:~10,4%%date:~4,2%%date:~7,2%
set logFile=%logPath%\%today%.log
set idocType=WPUBON WPUFIB WPUTAB WPUWBW
