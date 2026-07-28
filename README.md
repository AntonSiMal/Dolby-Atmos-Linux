# 🎧 Dolby Atmos Preset para Easy Effects

![Linux](https://img.shields.io/badge/OS-Linux-FCC624?logo=linux&logoColor=black)
![Easy Effects](https://img.shields.io/badge/App-Easy_Effects-7B68EE?logo=gnome)
![Audio](https://img.shields.io/badge/Audio-PipeWire-0078D7)
![License](https://img.shields.io/badge/License-MIT-green)

Este preset proporciona una experiencia de audio envolvente y optimizada para Linux, diseñado específicamente para mejorar la profundidad, la claridad y el escenario sonoro en altavoces y auriculares, simulando la sensación espacial de Dolby Atmos.

> [!IMPORTANT]
> **Easy Effects requiere PipeWire** como servidor de sonido. Si utilizas versiones antiguas de Ubuntu o Mint que aún usan PulseAudio por defecto, podrías experimentar problemas de compatibilidad (ver sección de solución de problemas).

---

## 🔍 ¿Para qué sirve y qué hace este preset?

Este no es un simple ecualizador; es una cadena de procesamiento de audio profesional (`plugins_order`) diseñada para transformar la salida de tu sistema:

1. **🎚️ Ecualizador de 10 Bandas (IIR):** 
   - **Graves (32Hz - 64Hz):** Refuerzo de +3dB y +2dB para dar peso y presencia.
   - **Medios (250Hz - 2000Hz):** Atenuación estratégica (-1dB a -2.5dB) para eliminar la sensación de sonido "encajonado" o sucio, mejorando la separación de instrumentos.
   - **Agudos (4000Hz - 16000Hz):** Ligero realce (+1dB a +2.5dB) para aportar "aire", brillo y claridad a las voces.
2. **🔊 Mejora de Graves (Bass Enhancer):** Genera armónicos psicoacústicos por debajo de 70Hz. Esto hace que los bajos se "sientan" más profundos en altavoces pequeños sin saturar el volumen.
3. **🌌 Convolución (Convolver):** El corazón del efecto "Atmos". Aplica una Respuesta al Impulso (IR) espacial para expandir el escenario sonoro. *(Requiere el archivo `.irs` incluido en este repositorio)*.
4. **🏛️ Reverberación (Reverb):** Configurada en "Sala Pequeña" (Small Room) con decaimiento corto (0.8s) y mezcla sutil (-20dB). Añade ambientación natural sin embarrar el audio.
5. **🛡️ Limitador (Limiter):** Configurado con umbral a `-0.03dB`. Actúa como red de seguridad final para evitar la distorsión digital (clipping) causada por la suma de ganancias de los efectos anteriores.

---

## 📦 Archivos incluidos en este repositorio

Para que el preset funcione al 100%, debes descargar **ambos** archivos de este repositorio:
1. `preset_dolby_atmos.json` (La configuración de Easy Effects).
2. `Dolby ATMOS ((128K MP3)) 1.Default.irs` (El archivo de Respuesta al Impulso para el plugin Convolver).

---

## 🚀 Guía de Instalación de Easy Effects

Dependiendo de tu distribución, utiliza los siguientes comandos:

### 1. Ubuntu y Linux Mint
Para versiones recientes (Ubuntu 22.04+ o Mint 21+):

* **Instalación estándar:**
  ```bash
  sudo apt update && sudo apt install easyeffects
  ```
* **Vía PPA (Recomendado para tener la última versión):**
  ```bash
  sudo add-apt-repository ppa:wwmm/easyeffects
  sudo apt update
  sudo apt install easyeffects
  ```

### 2. Arch Linux y Manjaro
En distribuciones basadas en Arch, el paquete suele estar siempre actualizado:

* **Instalación con Pacman:**
  ```bash
  sudo pacman -S easyeffects
  ```
* **Versión de desarrollo (AUR):**
  ```bash
  yay -S easyeffects-git
  ```

### 3. Método Universal (Flatpak) - ⭐ Recomendado
Es la forma más segura ya que incluye todas las dependencias necesarias y suele evitar conflictos de permisos.

1. **Instalar Flatpak** (si no lo tienes):
   * Ubuntu/Mint: `sudo apt install flatpak`
   * Arch/Manjaro: `sudo pacman -S flatpak`
2. **Instalar Easy Effects:**
   ```bash
   flatpak install flathub com.github.wwmm.easyeffects
   ```

---

## ⚠️ Nota importante sobre PipeWire

Si tras la instalación el programa no abre, se cierra solo o no detecta el servidor de sonido, activa PipeWire manualmente (especialmente en Ubuntu/Mint):

```bash
sudo apt install pipewire-audio-client-libraries libspa-0.2-bluetooth libspa-0.2-jack
systemctl --user --now enable pipewire pipewire-pulse wireplumber
```
*Nota: Es recomendable reiniciar tu sesión de usuario o el equipo completo después de ejecutar estos comandos.*

---

## 🛠️ Cómo aplicar este Preset correctamente

Sigue estos pasos para cargar la configuración en tu sistema:

1. **Descargar los archivos:** Descarga tanto el archivo `.json` como el archivo `.irs` de este repositorio.
2. **Instalar el archivo de Convolución (.irs):** 
   - Mueve el archivo `Dolby ATMOS ((128K MP3)) 1.Default.irs` a la carpeta de respuestas al impulso de Easy Effects.
   - Ruta: `~/.local/share/easyeffects/irs/` 
   - *(Si la carpeta `irs` no existe, créala manualmente).*
3. **Abrir la aplicación:** Inicia **Easy Effects** desde tu menú de aplicaciones.
4. **Importar el Preset:** 
   - Asegúrate de estar en la pestaña **Salida (Output)**.
   - Haz clic en el botón **Presets** ubicado en la esquina superior izquierda de la ventana.
   - Haz clic en el botón **Importar** (icono de carpeta o botón de texto) y selecciona el archivo `.json` que descargaste.
5. **Cargar el Preset:** 
   - Busca **"Dolby Atmos"** (o el nombre que tenga el archivo) en la lista de presets disponibles.
   - Haz clic en el **icono de la flecha hacia la derecha** (Cargar/Load) para activar todos los efectos en la cadena.

> [!TIP]
> Puedes marcar la casilla **Autoload** (o "Default" / Predeterminado) al lado del nombre del preset para que se aplique automáticamente cada vez que inicies sesión o conectes tus altavoces/auriculares.

---

## 🔧 Solución de Problemas

| Problema | Solución |
|----------|----------|
| **El plugin "Convolver" aparece en rojo o sin efecto** | El archivo `.irs` no está en la carpeta `~/.local/share/easyeffects/irs/` o el nombre no coincide exactamente con `Dolby ATMOS ((128K MP3)) 1.Default.irs`. |
| **No hay sonido o el audio se distorsiona** | El limitador está configurado a `-0.03dB`. Si hay distorsión, tu fuente de audio original ya está saturada. Baja el volumen del sistema o del reproductor. |
| **Easy Effects no detecta mis dispositivos** | Asegúrate de que PipeWire esté corriendo (`systemctl --user status pipewire`). Reinicia el servicio o el equipo si es necesario. |
| **El preset se desactiva al reiniciar (Flatpak)** | A veces hay problemas de permisos. Asegúrate de haber marcado la casilla de "Autoload" dentro de la app y de que los archivos estén en la ruta correcta del entorno Flatpak. |

---

## 📄 Licencia y Contribución

```text
MIT License • Sin garantías • Uso bajo responsabilidad del usuario.
El uso de procesamiento de audio a volúmenes muy altos puede dañar tu audición o equipos. Úsalo con responsabilidad.
```

**¿Quieres mejorar este preset?**
1. Haz un Fork del repositorio.
2. Ajusta los valores del JSON (por ejemplo, si tus altavoces necesitan más graves, sube la ganancia de la `band0` del ecualizador).
3. Abre un Pull Request describiendo qué tipo de hardware probaste (ej: "Edifier R1280T", "Sony WH-1000XM4", "Altavoces integrados de laptop").

---

> ⭐ **¿Te gustó el resultado?** Dale una estrella al repositorio.  
> 🔄 **Comparte tus resultados:** Si adaptas este preset para un modelo específico de hardware, ¡comparte tu experiencia en los Issues!  
> 🛡️ **Usa responsablemente**, siempre con un volumen moderado.
```
