# Compila el firmware para la Waveshare ESP32-S3-AUDIO-Board (Windows + PowerShell).
# Ajustá IDF_TOOLS_PATH y la ruta del venv de Python 3.11 a tu instalación de ESP-IDF.
$repo = Split-Path -Parent $PSScriptRoot
$env:IDF_TOOLS_PATH = 'D:\Espressif'
$idf = Join-Path $env:IDF_TOOLS_PATH 'frameworks\esp-idf-v5.5.1-2'
# El export.ps1 toma el primer Python del PATH: ponemos al frente el venv 3.11 de ESP-IDF.
$env:PATH = "$env:IDF_TOOLS_PATH\python_env\idf5.5_py3.11_env\Scripts;" + $env:PATH
# Si C: está justo de espacio, mové el temporal a otro disco.
$env:TMP = Join-Path $repo 'tmp'; $env:TEMP = $env:TMP
New-Item -ItemType Directory -Force $env:TMP | Out-Null
. "$idf\export.ps1"
Set-Location $repo
# Las comillas son necesarias: PowerShell parte el argumento en el punto.
$d = '-DSDKCONFIG_DEFAULTS=sdkconfig.defaults;sdkconfig.defaults.esp32s3;sdkconfig.defaults.pietro-wsaudio'
idf.py -B build-wsaudio "-DSDKCONFIG=sdkconfig.wsaudio" "$d" set-target esp32s3
idf.py -B build-wsaudio "-DSDKCONFIG=sdkconfig.wsaudio" "$d" build
