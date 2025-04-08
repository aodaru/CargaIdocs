# Job para el consumo de IDOCS ODOO -> SAP

Para realizar esta tarea necesitamos usar el programa startrfc que viene en la instalación de SAP.
El job busca los archivos de texto que comiencen con el nombre WPUBON y WPUFIB ya que el comando startrfc toma todos los archivos de texto que caigan en la ubicación donde se le indique que tome la data.

Esto lo controlamos mediante un ciclo for el cual ejecuta un dir en el directorio para que traiga por separado cada grupo de archivos.

```batch title:Ciclo_For
for /f "tokens=*" %%a in ('dir "%directorio%\WPUBON*.txt" /b') do (##CODIGO##)
for /f "tokens=*" %%a in ('dir "%directorio%\WPUFIB*.txt" /b') do (##CODIGO##)
```

Este proceso se ejecuta siempre que existan archivos en la ruta definida.
Utilizando **dir %directorio%\*.txt > nul** devuelve dentro de la variable ERRORLEVEL un valor 1 para vació y 0 para el caso contrario

```batch title:Validar_Datos_en_directorio
dir %directorio%\*.txt > nul

IF %ERRORLEVEL% == 0 (##CÓDIGO##)
```

### Parámetros

```batch title:Parámetros
REM Startrfc -h ipERP -s 00 -u usuario -p contrasena -c nmandante
REM -F EDI_DATA_INCOMING -E PATHNAME=c:\\InterfaceODOO\\ENTRADA\\WPUBON_0489.txt
REM puerta: -E PORT=IDOC -t
REM frecuentcia 3 min
REM Formato de fecha para el servidor de ERQ
REM %date:~7,2% -- dia
REM %date:~10,4% -- año
REM %date:~4,2% -- mes%

set server=172.30.30.33
set mand=200
set usr=soporte
set pwd=fJurado507/
set directorio=C:\\InterfaceODOO\\ENTRADA
set logPath=%directorio%\logs
set today=%date:~10,4%%date:~4,2%%date:~7,2%
set logFile=%logPath%\%today%.log
```

### Tarea programada

Se programo el Job para que se ejecute a partir de las 7:30 AM Hasta las 7:30 PM. Se estará ejecutando en intervalos de 3 minutos.

![Jobs](./img/ScheduleJob.png)

### Logs

Dentro de la carpeta de logs se estará almacenando los datos de cada ejecución.

### Código Fuente

```batch title:carga
@echo off

REM Startrfc -h ipERP -s 00 -u usuario -p contrasena -c nmandante
REM -F EDI_DATA_INCOMING -E PATHNAME=c:\\InterfaceODOO\\ENTRADA\\WPUBON_0489.txt
REM puerta: -E PORT=IDOC -t
REM frecuentcia 3 min
REM Formato de fecha para el servidor de ERQ
REM %date:~7,2% -- dia
REM %date:~10,4% -- año
REM %date:~4,2% -- mes%

set server=172.30.30.33
set mand=200
set usr=soporte
set pwd=fJurado507/
set directorio=C:\\InterfaceODOO\\ENTRADA
set logPath=%directorio%\logs
set today=%date:~10,4%%date:~4,2%%date:~7,2%
set logFile=%logPath%\%today%.log

dir %directorio%\*.txt > nul

IF %ERRORLEVEL% == 0 (
  IF NOT EXIST %logPath% mkdir %logPath%

  echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Inicio >> %logFile%

  for /f "tokens=*" %%a in ('dir "%directorio%\WPUBON*.txt" /b') do (
    echo procesando archivo %%a >> %logFile%
    startrfc -h %server% -s 00 -u %usr% -p %pwd% -c %mand% -F EDI_DATA_INCOMING -E PATHNAME=%directorio%\\%%a -E PORT=IDOC -t 3 >> %logFile%
  )

  for /f "tokens=*" %%a in ('dir "%directorio%\WPUFIB*.txt" /b') do (
    echo procesando archivo %%a >> %logFile%
    startrfc -h %server% -s 00 -u %usr% -p %pwd% -c %mand% -F EDI_DATA_INCOMING -E PATHNAME=%directorio%\\%%a -E PORT=IDOC -t 1 >> %logFile%
  )

  echo [%date:~7,2%/%date:~4,2%/%date:~10,4% - %time:~0,8%] - Fin >> %logFile%
  echo ************************************ >> %logFile%
)
```
