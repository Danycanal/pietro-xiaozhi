# pietro-xiaozhi

Fork de [xiaozhi-esp32](https://github.com/78/xiaozhi-esp32) (licencia MIT) con la configuración que usamos en Pietro: asistente de voz en **castellano** sobre placas **ESP32-S3** y la palabra de activación **"Pietro"**.

El README original quedó en [`README.upstream.md`](README.upstream.md). La licencia y los avisos de copyright originales se conservan en [`LICENSE`](LICENSE).

## Placas probadas

| Placa | Config | Notas |
|---|---|---|
| Waveshare ESP32-S3-AUDIO-Board | `sdkconfig.defaults.pietro-wsaudio` | I2C SDA 11 / SCL 10; I2S MCLK 12, BCLK 13, WS 14, DIN 15, DOUT 16; amplificador por el expansor TCA9555 |
| LAFVIN AI Chatbot (ESP32-S3 N16R8) | `sdkconfig.defaults.pietro` | ES8311 + ES7210; **otro pinout**, no son intercambiables |

Con el pinout equivocado la placa entra en bucle de reinicios (`ES8311: Open fail`).

## Qué cambia respecto del original

- `sdkconfig.defaults.pietro` y `sdkconfig.defaults.pietro-wsaudio`: placa, idioma `es-ES`, wake word personalizada "pietro" (MultiNet inglés, umbral 20).
- `main/audio/audio_service.cc`: arregla que, en códecs duplex, la salida se apagaba por leer el estado de la entrada *después* de apagarla. Síntoma: la placa mostraba "Hablando" y recibía la respuesta pero **no sonaba nada**.
- `main/audio/wake_words/custom_wake_word.cc`: idioma por defecto `en` en lugar de `cn` cuando no hay lista de modelos.
- `scripts/build-wsaudio.ps1`: compilación en Windows con las trampas resueltas.

## Compilar

Requiere ESP-IDF 5.5. En Windows:

```powershell
.\scripts\build-wsaudio.ps1
```

Flasheo (ajustá el puerto):

```
python -m esptool --chip esp32s3 --port COM15 -b 460800 write_flash --flash_mode dio --flash_size 16MB --flash_freq 80m @build-wsaudio/flash_args
```

Trampas del build en Windows:
- El `export.ps1` de ESP-IDF usa el primer Python del PATH; hay que poner al frente el venv 3.11 de ESP-IDF.
- Si el disco del sistema está lleno, el compilador falla con errores engañosos: mové `TMP`/`TEMP`.
- En PowerShell, los `-DX=a.b` van entre comillas o `idf.py` los parte en el punto.

## Servidor

Por defecto la placa se activa contra el servidor oficial de xiaozhi (`CONFIG_OTA_URL`). cuando tengas la placa activa , buscala con wifi , desde el celular o una pc . configuras el wifi del esp a una coneccion de internet. y la asocias en la web de https://xiaozhi.me/ creas una cuenta, vas a console , registras el equipo segun el numero que te dicta el audio de la placa . 

## Aviso

Proyecto personal Daniel Pietroboni, sin garantía ni relación con Espressif, Waveshare, LAFVIN ni los autores de xiaozhi-esp32.
