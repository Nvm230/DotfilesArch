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
for APP in "${APPS[@]}"; do
    # 1. Limpieza: Borrar siempre el enlace o carpeta actual en .config
    rm -rf "$CONFIG_DIR/$APP"

    # 2. Verificación: ¿Existe la carpeta en el perfil destino?
    if [ -d "$PERFILES_DIR/$PERFIL/$APP" ]; then
        # SI existe -> Creamos el enlace
        ln -s "$PERFILES_DIR/$PERFIL/$APP" "$CONFIG_DIR/$APP"
        echo " -> $APP conectado a $PERFIL"
    else
        # NO existe -> Solo informamos (ya se borró el enlace viejo arriba)
        # Esto evita errores de "fichero no encontrado"
        echo "$APP no existe en $PERFIL (Omitido)"
    fi
done

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
