#!/bin/bash

# Matar instancias previas para no duplicar
pkill -f "wl-paste --watch"

# 1. Dirección Linux (Wayland) -> Windows (X11)
# Si copias en Hyprland, se manda a xclip (que lo manda a VMware)
wl-paste --watch xclip -selection clipboard &

# 2. Dirección Windows (X11) -> Linux (Wayland)
# Bucle infinito suave que revisa cada segundo si VMware trajo algo nuevo
while true; do
    # Leer el contenido de ambos portapapeles
    X_CLIP=$(xclip -o -selection clipboard 2>/dev/null)
    W_CLIP=$(wl-paste 2>/dev/null)

    # Si X11 tiene algo (no vacío) Y es diferente a lo que tiene Wayland...
    if [ -n "$X_CLIP" ] && [ "$X_CLIP" != "$W_CLIP" ]; then
        # ...actualizamos Wayland
        echo -n "$X_CLIP" | wl-copy
    fi
    sleep 1
done
