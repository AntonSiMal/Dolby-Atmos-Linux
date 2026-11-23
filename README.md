# 🎧 Dolby Atmos Presets para Easy Effects (Linux)

![Linux](https://img.shields.io/badge/OS-Linux-FCC624?logo=linux&logoColor=black)
![Easy Effects](https://img.shields.io/badge/App-Easy_Effects-7B68EE?logo=gnome)
![Audio](https://img.shields.io/badge/Audio-PipeWire-0078D7)
![License](https://img.shields.io/badge/License-MIT-green)

Colección de perfiles profesionales de procesamiento DSP para **Easy Effects** en Linux, diseñados para simular la profundidad, claridad vocal y escena espacial tridimensional de **Dolby Atmos** tanto en **audífonos** como en **altavoces estéreo**.

> [!IMPORTANT]
> **Easy Effects requiere PipeWire** como servidor de sonido. Si utilizas distribuciones configuradas con PulseAudio por defecto, revisa la sección de solución de problemas más abajo.

---

## 📦 Perfiles incluidos en el repositorio

El proyecto separa el procesamiento acústico según el dispositivo de salida, ya que los audífonos requieren virtualización binaural HRTF y los altavoces requieren control de fase, diafonía y sala:

| Archivo | Dispositivo | Versión | Arquitectura DSP |
| :--- | :--- | :--- | :--- |
| `Dolby Atmos Headphones.json` | 🎧 Audífonos | **Estable** | EQ 10 bandas + Bass Enhancer + Convolver + Reverb suave + Limiter. |
| `Dolby Atmos Space.json` | 🔊 Altavoces | **Estable** | EQ + Bass Enhancer + Reverb de sala + Stereo Base + Limiter (sin convolver binaural). |
| `Dolby Atmos Headphones (Beta).json` | 🎧 Audífonos | **Beta** | **Arquitectura calibrada:** EQ con filtros *Bell* (`-3.5 dB` *headroom*, claridad vocal en `1–2 kHz`), Bass Enhancer contenido (`30–75 Hz`), Compresor Multibanda con *sidechain* en `Middle`, Convolver HRTF (`wet: -2 dB`), Stereo Tools post-convolución (`side-level: 2.0`, `stereo-base: 0.2`, `delay: 0.0`) y Limiter con *oversampling* (`-0.5 dB`). |
| `Dolby Atmos Space (beta).json` | 🔊 Altavoces | **Beta** | **Arquitectura calibrada:** Filtro *High-Pass* protector a `40 Hz` + EQ balanceado (`-2.5 dB` *headroom*), realce armónico controlado (`45–80 Hz`), reverb de sala pequeña (`0.45s` a `-26 dB`, `predelay: 12 ms`), expansión estéreo limpia (`side-level: 1.5`, `stereo-base: 0.2`, `delay: 0.0`) y Limiter con *oversampling* (`-0.5 dB`). |
| `Dolby ATMOS ((128K MP3)) 1.Default.irs` | 🌌 Impulso | **Requerido** | Archivo de Respuesta al Impulso (IR) espacial utilizado por el plugin **Convolver** (activo en los perfiles de audífonos). |

---

## ⚡ Instalación Rápida (Recomendada)

El repositorio incluye un script automático (`install.sh`) que detecta si tienes Easy Effects instalado de forma **Nativa** o mediante **Flatpak**, verifica las dependencias LV2 del sistema y copia los archivos en los directorios exactos.

1. **Clona el repositorio:**
   ```bash
   git clone [https://github.com/AntonSiMal/Dolby-Atmos-Linux.git](https://github.com/AntonSiMal/Dolby-Atmos-Linux.git)
   cd Dolby-Atmos-Linux

```

2. **Ejecuta el instalador:**
```bash
chmod +x install.sh
./install.sh

```



### Opciones de instalación

Al ejecutar `./install.sh` sin argumentos se abrirá un menú interactivo, o puedes pasar directamente cualquiera de estas banderas:

* `./install.sh --stable` (o `-s`): Instala únicamente los perfiles **Estables** (`Headphones` y `Space`).
* `./install.sh --beta` (o `-b`): Instala únicamente los perfiles **Beta** con la arquitectura calibrada.
* `./install.sh --all` (o `-a`): Instala los **4 perfiles** para alternar y comparar entre ellos.

---

## 🛠️ Requisitos e Instalación de Easy Effects

### 1. Instalar Easy Effects

* **Método Universal (Flatpak - Recomendado):**
Incluye todas las librerías de audio compiladas dentro del entorno sin depender de paquetes del sistema.
```bash
flatpak install flathub com.github.wwmm.easyeffects

```


* **Ubuntu / Linux Mint (Nativo):**
```bash
sudo apt update && sudo apt install -y easyeffects lsp-plugins-lv2 calf-plugins

```


* **Arch Linux / Manjaro (Nativo):**
```bash
sudo pacman -S easyeffects lsp-plugins-lv2 calf

```


* **Fedora (Nativo):**
```bash
sudo dnf install easyeffects lsp-plugins-lv2 calf

```



> [!NOTE]
> Si utilizas la **instalación nativa**, asegúrate de tener instalados `lsp-plugins-lv2` y `calf-plugins`; de lo contrario, los bloques *Multiband Compressor*, *Stereo Tools* o *Limiter* aparecerán deshabilitados en la interfaz. El script `./install.sh` comprueba esto automáticamente.

---

## 📂 Instalación Manual (Opcional)

Si prefieres copiar los archivos sin usar el script, colócalos según tu tipo de instalación:

* **Instalación Nativa:**
* Presets (`.json`): `~/.local/share/easyeffects/output/`
* Impulso (`.irs`): `~/.local/share/easyeffects/irs/`


* **Instalación Flatpak:**
* Presets (`.json`): `~/.var/app/com.github.wwmm.easyeffects/data/easyeffects/output/`
* Impulso (`.irs`): `~/.var/app/com.github.wwmm.easyeffects/data/easyeffects/irs/`



---

## 🔄 Cambio Automático entre Audífonos y Altavoces (Autoload)

Puedes configurar **Easy Effects** para que cambie solo entre el perfil de audífonos y el de altavoces al conectar o desconectar el cable o dispositivo Bluetooth:

1. **Con los audífonos desconectados:**
* Abre **Easy Effects** → pestaña **Salida (Output)** → **Presets** y carga **`Dolby Atmos Space (beta)`** (o la versión estable).
* Ve a la pestaña **Autoload** dentro del mismo menú de Presets, verifica que el perfil activo sea `Speaker` (o `analog-output-speaker`) y haz clic en **Añadir (+)**.


2. **Conecta tus audífonos (3.5 mm, USB o Bluetooth):**
* En **Presets**, carga **`Dolby Atmos Headphones (Beta)`**.
* Ve a **Autoload**, verifica que el perfil haya cambiado a `Headphones` (o al nombre de tu dispositivo Bluetooth/USB) y haz clic en **Añadir (+)**.



A partir de ese momento, Easy Effects alternará automáticamente entre ambos perfiles cada vez que cambies de dispositivo de salida.

---

## 🔧 Solución de Problemas

| Problema | Causa y Solución |
| --- | --- |
| **El plugin "Convolver" aparece en rojo o sin efecto** | El archivo `Dolby ATMOS ((128K MP3)) 1.Default.irs` no está en la carpeta `irs/` correspondiente (Nativa o Flatpak). Ejecuta `./install.sh` para copiarlo en la ruta correcta. *(Nota: En los perfiles `Space` para altavoces, el Convolver está desactivado intencionalmente para evitar cancelación de fase en bocinas).* |
| **Un plugin aparece en gris / deshabilitado** | En instalaciones nativas faltan los motores LV2. Instala `lsp-plugins-lv2` y `calf-plugins` y reinicia el servicio con `easyeffects -q && easyeffects --gapplication-service &`. |
| **Easy Effects no abre o no detecta audio** | Activa PipeWire en tu sesión ejecutando `systemctl --user --now enable pipewire pipewire-pulse wireplumber` y reinicia sesión. |
| **Saturación en canciones con muchos graves** | En los perfiles Beta, el `input-gain` del ecualizador está calibrado (`-3.5 dB` en Headphones y `-2.5 dB` en Space) con limitador en `-0.5 dB`. Si tu fuente de audio ya viene saturada, baja ligeramente el volumen de la aplicación reproductora. |

---

## 📄 Licencia y Contribución

Distribuido bajo la **MIT License**. Úsalo bajo tu propia responsabilidad y mantén volúmenes moderados para cuidar tu audición y tus equipos.

¿Tienes sugerencias o ajustes calibrados para un modelo específico de audífonos o monitores? ¡Abre un **Issue** o envía un **Pull Request**!

```

<ElicitationsGroup message="Si deseas añadir algún extra antes de hacer el commit final:">
  <Elicitation label="Agregar opción --uninstall al script install.sh" query="Agrega la opción --uninstall al menú y argumentos de install.sh para desinstalar los presets y el archivo .irs."/>
  <Elicitation label="Crear plantilla de Issues para pruebas de hardware" query="Genera una plantilla corta de Issues en Markdown para que los usuarios reporten pruebas de hardware con los presets Beta."/>
</ElicitationsGroup>

```
