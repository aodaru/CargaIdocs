@echo off 

REM Startrfc -h ipERP -s 00 -u usuario -p contrasena -c nmandante
REM -F EDI_DATA_INCOMING -E PATHNAME=c:\InterfaceODOO\ENTRADA\WPUBON_0489.txt 
REM puerta: -E PORT=IDOC -t
REM frecuentcia 5 min
REM Formato de fecha para el servidor de ERQ 
REM %date:~7,2% -- dia
REM %date:~10,4% -- año
REM %date:~4,2% -- mes%

CALL ./config.bat 

echo %directorio%
IF NOT EXIST %directorio% mkdir %directorio%
dir %directorio%\*.txt > nul

IF %ERRORLEVEL% == 0 (
  IF NOT EXIST %logPath% mkdir %logPath%
  IF NOT EXIST %duplicatePath% mkdir %duplicatePath% 

  echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Inicio >> %logFile% 

  for %%f in (%idocType%) do (
    for /f "tokens=*" %%a in ('dir "%directorio%\%f%*.txt" /b') do (
      echo procesando archivo %%a >> %logFile%
      echo startrfc -h %server% -s 00 -u %usr% -p %pwd% -c %mand% -F EDI_DATA_INCOMING -E PATHNAME=%directorio%\%%a -E PORT=IDOC >> %logFile%
    )
  )

  echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Fin >> %logFile% 
  echo ************************************ >> %logFile% 
)
