@echo off 

CALL ./config.bat 

IF NOT EXIST %directorio% mkdir %directorio%
dir %directorio%\*.txt > nul

IF %ERRORLEVEL% == 0 (
  IF NOT EXIST %logPath% mkdir %logPath%
  IF NOT EXIST %duplicatePath% mkdir %duplicatePath% 

  echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Inicio >> %logFile% 

  for %%f in (%idocType%) do (
    if NOT %%f == "" (
      for /f "tokens=*" %%a in ('dir "%directorio%\%%f*.txt" /b') do (
        if NOT %%a == "" (
          CALL :checkDuplicate "%%a"
        )
      )
    )
  )

  echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Fin >> %logFile% 
  echo ************************************ >> %logFile% 
)

:checkDuplicate
  findstr /C:" %~1" "%logFile%" >nul
  if %errorlevel% == 0 (
    if NOT %~1 == " " (
      echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Archivo %~1 ya procesado. >> "%logFile%"
      move "%directorio%\%~1" "%duplicatePath%\%date:~7,2%%date:~4,2%%date:~10,4%_%time:~0,2%%time:~0,2%%time:~6,2%_%~1"
    )
    exit /b 1
  ) else (
    echo procesando archivo %~1 >> %logFile%
    startrfc -h %server% -s 00 -u %usr% -p %pwd% -c %mand% -F EDI_DATA_INCOMING -E PATHNAME=%directorio%\%~1 -E PORT=IDOC >> %logFile%
    exit /b 0
  )
