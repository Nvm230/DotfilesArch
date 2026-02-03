#!/bin/bash

# Perfil a cargar (ctf, prog, chill)
PERFIL=$1

if [ -z "$PERFIL" ]; then
    echo "Uso: ./switch.sh [ctf|prog|chill]"
    exit 1
fi

CONFIG_DIR="$HOME/.config"
PERFILES_DIR="$HOME/.config/perfiles"

# ---------------------------------------------------------
# LISTA MAESTRA DE APPS
# Pon aquí TODAS las carpetas que existen en cualquiera de tus perfiles.
# (He combinado las que vi en tu ls de CTF y PROG)
# ---------------------------------------------------------
APPS=(
    "hypr"
    "waybar"
    "kitty"
    "cava"
    "fastfetch"
    "neofetch"
    "rofi"
    "dunst"
    "wlogout"
    "wal"
    "fish"
)

echo "Cambiando a perfil: $PERFIL..."

# Bucle inteligente
# Bucle inteligente
for APP in "${APPS[@]}"; do
    SOURCE_PATH="$PERFILES_DIR/$PERFIL/$APP"
    DEST_PATH="$CONFIG_DIR/$APP"

    # 1. Verificación: ¿Existe la carpeta en el perfil destino?
    if [ -d "$SOURCE_PATH" ] || [ -f "$SOURCE_PATH" ]; then
        # 2. Limpieza: Borrar el enlace o carpeta actual SOLO si tenemos reemplazo
        rm -rf "$DEST_PATH"
        
        # 3. Crear el enlace
        ln -s "$SOURCE_PATH" "$DEST_PATH"
        echo " -> $APP conectado a $PERFIL"
    else
        # NO existe -> Solo informamos, NO borramos lo que ya hay
        echo "[!] $APP no existe en $PERFIL (Manteniendo configuración actual)"
    fi
done

# Guardar estado actual
echo "$PERFIL" > "$PERFILES_DIR/current_profile"

# ---------------------------------------------------------
# RECARGA DE SERVICIOS
# ---------------------------------------------------------
echo "Recargando entorno..."

# Recargar Hyprland
hyprctl reload

# Reiniciar Waybar (siempre)
killall waybar
waybar & disown

# Reiniciar Dunst (Solo si se enlazó en este perfil)
if [ -d "$CONFIG_DIR/dunst" ]; then
    killall dunst
    dunst & disown
fi

# Notificación
notify-send "Perfil Activado" "Modo $PERFIL cargado" 2>/dev/null

echo "Done"
