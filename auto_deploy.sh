#!/bin/bash

# Configuración
URL_WEBHOOK="http://<IP_DE_TU_SERVIDOR>:8000/webhook.php"
SECRETO="mi_clave_secreta_123"

# Variables para la lógica del commit
MENSAJE_POR_DEFECTO="Actualización automática de código"
ULTIMO_MENSAJE=""

echo "Iniciando bucle de despliegue continuo..."
echo "Presiona Ctrl+C para salir."
echo "----------------------------------------"

while true; do
    # Pedimos el nombre del commit
    read -p "Nombre del commit (Enter para usar el anterior): " input_usuario

    # Lógica de asignación del mensaje
    if [ -z "$input_usuario" ]; then
        # Si el usuario dio Enter sin escribir nada
        if [ -n "$ULTIMO_MENSAJE" ]; then
            MENSAJE_ACTUAL="$ULTIMO_MENSAJE"
        else
            MENSAJE_ACTUAL="$MENSAJE_POR_DEFECTO"
        fi
    else
        # Si el usuario escribió algo, lo usamos y lo guardamos para la próxima
        MENSAJE_ACTUAL="$input_usuario"
        ULTIMO_MENSAJE="$input_usuario"
    fi

    echo "=> Preparando Git con el mensaje: '$MENSAJE_ACTUAL'"
    
    # Comandos Git
    git add .
    git commit -m "$MENSAJE_ACTUAL"
    git push

    # Verificamos si el push fue exitoso (código de salida 0)
    if [ $? -eq 0 ]; then
        echo "=> Notificando al servidor para que actualice..."
        
        # Hacemos la petición POST con curl
        curl -X POST "$URL_WEBHOOK" -d "secreto=$SECRETO"
        
        echo -e "\n=> Despliegue completado con éxito."
    else
        echo "=> Hubo un problema con git push. No se notificó al servidor."
    fi

    echo "----------------------------------------"
    echo "Esperando nuevos cambios..."
done
