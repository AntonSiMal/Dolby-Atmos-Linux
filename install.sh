#!/usr/bin/env bash

set -euo pipefail

# Colores para la salida en terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # Sin color

# Listas de presets del repositorio
STABLE_PRESETS=(
    "Dolby Atmos Headphones.json"
    "Dolby Atmos Space.json"
)

BETA_PRESETS=(
    "Dolby Atmos Headphones (Beta).json"
    "Dolby Atmos Space (beta).json"
)

ALL_PRESETS=("${STABLE_PRESETS[@]}" "${BETA_PRESETS[@]}")

# Impulsos soportados (actual MP3 + futuro nativo 48kHz)
IRS_FILES=(
    "Dolby ATMOS ((128K MP3)) 1.Default.irs"
    "Dolby_Atmos_Native_48k.irs"
)

# Rutas de instalación de Easy Effects
NATIVE_DIR="$HOME/.local/share/easyeffects"
FLATPAK_DIR="$HOME/.var/app/com.github.wwmm.easyeffects/data/easyeffects"

# Directorio donde se ejecuta este script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}   Instalador de Dolby Atmos Preset - Easy Effects  ${NC}"
echo -e "${BLUE}====================================================${NC}\n"

# Función para desinstalar presets e impulsos de ambas rutas (Nativa y Flatpak)
uninstall_presets() {
    echo -e "${YELLOW}[*] Iniciando desinstalación de perfiles Dolby Atmos...${NC}\n"
    local removed_total=0

    for base_dir in "$NATIVE_DIR" "$FLATPAK_DIR"; do
        local output_dir="$base_dir/output"
        local irs_dir="$base_dir/irs"
        local removed_in_path=0

        if [[ -d "$output_dir" ]]; then
            for preset in "${ALL_PRESETS[@]}"; do
                if [[ -f "$output_dir/$preset" ]]; then
                    rm -f "$output_dir/$preset"
                    echo -e "  ${RED}✘ Eliminado:${NC} $output_dir/$preset"
                    removed_in_path=$((removed_in_path + 1))
                fi
            done
        fi

        if [[ -d "$irs_dir" ]]; then
            for irs in "${IRS_FILES[@]}"; do
                if [[ -f "$irs_dir/$irs" ]]; then
                    rm -f "$irs_dir/$irs"
                    echo -e "  ${RED}✘ Eliminado:${NC} $irs_dir/$irs"
                    removed_in_path=$((removed_in_path + 1))
                fi
            done
        fi

        removed_total=$((removed_total + removed_in_path))
    done

    echo ""
    if [[ $removed_total -gt 0 ]]; then
        echo -e "${GREEN}[OK] Desinstalación completada ($removed_total archivos eliminados).${NC}"
    else
        echo -e "${YELLOW}[AVISO] No se encontraron archivos instalados de Dolby Atmos en el sistema.${NC}"
    fi
    exit 0
}

# 1. Selección de acción/versión (por argumento o menú interactivo)
CHOICE="${1:-}"

if [[ -z "$CHOICE" ]]; then
    echo -e "${CYAN}Selecciona una opción:${NC}"
    echo -e "  ${GREEN}1)${NC} Instalar Versión Estable  (Dolby Atmos Headphones & Space)"
    echo -e "  ${YELLOW}2)${NC} Instalar Versión Beta     (Arquitectura calibrada Mid/Side + High-Pass 40Hz)"
    echo -e "  ${BLUE}3)${NC} Instalar Ambas versiones  (Instala los 4 perfiles)"
    echo -e "  ${RED}4)${NC} Desinstalar perfiles      (Elimina los presets e impulsos instalados)"
    echo -e "  ${NC}5)${NC} Cancelar\n"
    read -rp "Opción [1-5]: " OPTION

    case "$OPTION" in
        1) CHOICE="--stable" ;;
        2) CHOICE="--beta" ;;
        3) CHOICE="--all" ;;
        4) CHOICE="--uninstall" ;;
        5) echo -e "\n${YELLOW}Operación cancelada.${NC}"; exit 0 ;;
        *) echo -e "\n${RED}[ERROR] Opción no válida.${NC}"; exit 1 ;;
    esac
    echo ""
fi

SELECTED_PRESETS=()
case "$CHOICE" in
    --stable|-s)
        SELECTED_PRESETS=("${STABLE_PRESETS[@]}")
        echo -e "${GREEN}[*] Modo seleccionado: Versión Estable${NC}\n"
        ;;
    --beta|-b)
        SELECTED_PRESETS=("${BETA_PRESETS[@]}")
        echo -e "${YELLOW}[*] Modo seleccionado: Versión Beta${NC}\n"
        ;;
    --all|-a)
        SELECTED_PRESETS=("${ALL_PRESETS[@]}")
        echo -e "${BLUE}[*] Modo seleccionado: Todas las versiones (Estable + Beta)${NC}\n"
        ;;
    --uninstall|-u)
        uninstall_presets
        ;;
    --help|-h)
        echo -e "Uso: ./install.sh [OPCIÓN]"
        echo -e "  --stable, -s     Instala únicamente los perfiles Estables"
        echo -e "  --beta, -b       Instala únicamente los perfiles Beta"
        echo -e "  --all, -a        Instala los 4 perfiles (Estable + Beta)"
        echo -e "  --uninstall, -u  Elimina todos los presets e impulsos instalados"
        exit 0
        ;;
    *)
        echo -e "${RED}[ERROR] Parámetro desconocido:${NC} $CHOICE"
        echo -e "Uso: ./install.sh [--stable | --beta | --all | --uninstall]"
        exit 1
        ;;
esac

# 2. Validar que al menos un archivo de impulso (.irs) exista en el repositorio
FOUND_IRS=()
for irs in "${IRS_FILES[@]}"; do
    if [[ -f "$SCRIPT_DIR/$irs" ]]; then
        FOUND_IRS+=("$irs")
    fi
done

if [[ ${#FOUND_IRS[@]} -eq 0 ]]; then
    echo -e "${RED}[ERROR] No se encontró ningún archivo de impulso (.irs) en el repositorio.${NC}"
    echo -e "${YELLOW}Asegúrate de ejecutar ./install.sh desde la carpeta raíz del repositorio.${NC}"
    exit 1
fi

# 3. Validar que los archivos seleccionados existan en el repositorio
FOUND_PRESETS=()
for preset in "${SELECTED_PRESETS[@]}"; do
    if [[ -f "$SCRIPT_DIR/$preset" ]]; then
        FOUND_PRESETS+=("$preset")
    else
        echo -e "${YELLOW}[AVISO] No se encontró el archivo:${NC} $preset"
    fi
done

if [[ ${#FOUND_PRESETS[@]} -eq 0 ]]; then
    echo -e "${RED}[ERROR] No se encontró ningún archivo .json válido para la opción seleccionada.${NC}"
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

    for irs in "${FOUND_IRS[@]}"; do
        cp -f "$SCRIPT_DIR/$irs" "$irs_dir/"
    done

    echo -e "${GREEN}[OK] ${#FOUND_PRESETS[@]} presets instalados en:${NC} $output_dir"
    echo -e "${GREEN}[OK] ${#FOUND_IRS[@]} impulso(s) (.irs) instalado(s) en:${NC} $irs_dir\n"
}

# Función para verificar dependencias LV2 en instalaciones nativas
check_lv2_plugins() {
    local lv2_dirs=("/usr/lib/lv2" "/usr/lib64/lv2" "/usr/local/lib/lv2" "$HOME/.lv2")
    local has_lsp=0
    local has_calf=0

    for dir in "${lv2_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            ls "$dir" 2>/dev/null | grep -qi "lsp-plugins" && has_lsp=1
            ls "$dir" 2>/dev/null | grep -qi "calf" && has_calf=1
        fi
    done

    if [[ $has_lsp -eq 0 || $has_calf -eq 0 ]]; then
        echo -e "${YELLOW}[!] Verificación de dependencias LV2 (Instalación Nativa):${NC}"
        [[ $has_lsp -eq 0 ]] && echo -e "  ${RED}✘ Falta LSP Plugins${NC} (necesario para Equalizer, Multiband Compressor, Convolver y Limiter)"
        [[ $has_calf -eq 0 ]] && echo -e "  ${RED}✘ Falta Calf Studio Gear${NC} (necesario para Bass Enhancer, Reverb y Stereo Tools)"

        echo -e "\n  Instálalos ejecutando el comando correspondiente a tu sistema:"
        if command -v apt &> /dev/null; then
            echo -e "  ${BLUE}sudo apt update && sudo apt install -y lsp-plugins-lv2 calf-plugins${NC}\n"
        elif command -v pacman &> /dev/null; then
            echo -e "  ${BLUE}sudo pacman -S lsp-plugins-lv2 calf${NC}\n"
        elif command -v dnf &> /dev/null; then
            echo -e "  ${BLUE}sudo dnf install lsp-plugins-lv2 calf${NC}\n"
        elif command -v zypper &> /dev/null; then
            echo -e "  ${BLUE}sudo zypper install lsp-plugins-lv2 calf${NC}\n"
        else
            echo -e "  ${BLUE}Instala 'lsp-plugins-lv2' y 'calf-plugins' desde tu gestor de paquetes.${NC}\n"
        fi
    else
        echo -e "${GREEN}[OK] Plugins LV2 requeridos (LSP y Calf) detectados en el sistema.${NC}\n"
    fi
}

INSTALLED_COUNT=0
NATIVE_DETECTED=0

# 4. Detectar instalación Nativa (apt, pacman, dnf, etc.)
if command -v easyeffects &> /dev/null || [[ -d "$NATIVE_DIR" ]]; then
    install_to_path "$NATIVE_DIR" "Nativa (Sistema)"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    NATIVE_DETECTED=1
fi

# 5. Detectar instalación Flatpak
if command -v flatpak &> /dev/null && flatpak list --app 2>/dev/null | grep -q "com.github.wwmm.easyeffects"; then
    install_to_path "$FLATPAK_DIR" "Flatpak"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
elif [[ -d "$HOME/.var/app/com.github.wwmm.easyeffects" ]]; then
    install_to_path "$FLATPAK_DIR" "Flatpak"
    INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
fi

# 6. Fallback si Easy Effects aún no ha sido ejecutado o instalado
if [[ $INSTALLED_COUNT -eq 0 ]]; then
    echo -e "${YELLOW}[AVISO] No se detectó una instalación activa de Easy Effects.${NC}"
    echo -e "Se crearán las carpetas predeterminadas en ambas rutas para que estén listas al instalarlo:\n"
    install_to_path "$NATIVE_DIR" "Nativa (Por defecto)"
    install_to_path "$FLATPAK_DIR" "Flatpak (Por defecto)"
fi

# 7. Ejecutar verificación de plugins LV2 si hay instalación nativa
if [[ $NATIVE_DETECTED -eq 1 ]]; then
    check_lv2_plugins
fi

# 8. Verificar si PipeWire está activo
if command -v systemctl &> /dev/null; then
    if ! systemctl --user is-active --quiet pipewire; then
        echo -e "${YELLOW}[!] Advertencia: El servicio PipeWire no parece estar activo en esta sesión.${NC}"
        echo -e "    Ejecuta: ${BLUE}systemctl --user --now enable pipewire pipewire-pulse wireplumber${NC}\n"
    fi
fi

echo -e "${GREEN}¡Instalación completada con éxito!${NC}"
echo -e "Abre ${BLUE}Easy Effects${NC} → pestaña ${BLUE}Salida (Output)${NC} → ${BLUE}Presets${NC} para cargar:\n"
for preset in "${FOUND_PRESETS[@]}"; do
    echo -e "  • ${YELLOW}${preset%.json}${NC}"
done
echo ""
