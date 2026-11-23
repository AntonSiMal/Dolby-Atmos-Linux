#!/usr/bin/env bash

set -euo pipefail

# Colores para la salida en terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Lista exacta de presets en el repositorio
PRESETS=(
    "Dolby Atmos Headphones.json"
    "Dolby Atmos Headphones (Beta).json"
    "Dolby Atmos Space.json"
    "Dolby Atmos Space (beta).json"
)

IRS_FILE="Dolby ATMOS ((128K MP3)) 1.Default.irs"

# Directorio donde se ejecuta este script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}   Instalador de Dolby Atmos Preset - Easy Effects  ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# 1. Validar que el archivo de impulso (.irs) exista
if [[ ! -f "$SCRIPT_DIR/$IRS_FILE" ]]; then
    echo -e "${RED}[ERROR] No se encontró el archivo de impulso:${NC} $IRS_FILE"
    echo -e "${YELLOW}Asegúrate de ejecutar ./install.sh desde la carpeta raíz del repositorio.${NC}"
    exit 1
fi

# 2. Validar que al menos exista un preset en la carpeta
FOUND_PRESETS=()
for preset in "${PRESETS[@]}"; do
    if [[ -f "$SCRIPT_DIR/$preset" ]]; then
        FOUND_PRESETS+=("$preset")
    else
        echo -e "${YELLOW}[AVISO] No se encontró el archivo opcional:${NC} $preset"
    fi
done

if [[ ${#FOUND_PRESETS[@]} -eq 0 ]]; then
    echo -e "${RED}[ERROR] No se encontró ningún archivo .json de preset en el directorio.${NC}"
    exit 1
fi

# Función para copiar los archivos a una ruta base de Easy Effects
install_to_path() {
    local base_dir="$1"
    local install_type="$2"
    local output_dir="$base_dir/output"
    local irs_dir="$base_dir/irs"

    echo -e "${BLUE}[*] Instalando para versión $install_type...${NC}"
    mkdir -p "$output_dir" "$irs_dir"

    for preset in "${FOUND_PRESETS[@]}"; do
        cp -f "$SCRIPT_DIR/$preset" "$output_dir/"
    done

    cp -f "$SCRIPT_DIR/$IRS_FILE" "$irs_dir/"

    echo -e "${GREEN}[OK] ${#FOUND_PRESETS[@]} presets instalados en:${NC} $output_dir"
    echo -e "${GREEN}[OK] Impulso (.irs) instalado en:${NC} $irs_dir\n"
}

INSTALLED_COUNT=0

# 3. Detectar instalación Nativa (apt, pacman, dnf, etc.)
NATIVE_DIR="$HOME/.local/share/easyeffects"
if command -v easyeffects &> /dev/null || [[ -d "$NATIVE_DIR" ]]; then
    install_to_path "$NATIVE_DIR" "Nativa (Sistema)"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
fi

# 4. Detectar instalación Flatpak
FLATPAK_DIR="$HOME/.var/app/com.github.wwmm.easyeffects/data/easyeffects"
if command -v flatpak &> /dev/null && flatpak list --app 2>/dev/null | grep -q "com.github.wwmm.easyeffects"; then
    install_to_path "$FLATPAK_DIR" "Flatpak"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
elif [[ -d "$HOME/.var/app/com.github.wwmm.easyeffects" ]]; then
    install_to_path "$FLATPAK_DIR" "Flatpak"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
fi

# 5. Fallback si Easy Effects aún no ha sido ejecutado o instalado
if [[ $INSTALLED_COUNT -eq 0 ]]; then
    echo -e "${YELLOW}[AVISO] No se detectó una instalación activa de Easy Effects.${NC}"
    echo -e "Se crearán las carpetas predeterminadas en ambas rutas para que estén listas al instalarlo:\n"
    install_to_path "$NATIVE_DIR" "Nativa (Por defecto)"
    install_to_path "$FLATPAK_DIR" "Flatpak (Por defecto)"
fi

# 6. Verificar si PipeWire está activo
if command -v systemctl &> /dev/null; then
    if ! systemctl --user is-active --quiet pipewire; then
        echo -e "${YELLOW}[!] Advertencia: El servicio PipeWire no parece estar activo en esta sesión.${NC}"
        echo -e "    Ejecuta: ${BLUE}systemctl --user --now enable pipewire pipewire-pulse wireplumber${NC}\n"
    fi
fi

echo -e "${GREEN}¡Instalación completada con éxito!${NC}"
echo -e "Abre ${BLUE}Easy Effects${NC} → pestaña ${BLUE}Salida (Output)${NC} → ${BLUE}Presets${NC} para cargar cualquiera de los perfiles instalados:\n"
for preset in "${FOUND_PRESETS[@]}"; do
    echo -e "  • ${YELLOW}${preset%.json}${NC}"
done
echo ""
