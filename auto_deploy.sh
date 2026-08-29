#!/bin/bash

#colores
W="\e[0m"
N="\e[38;2;100;102;109m"
n="\e[30m"
R="\e[38;2;255;0;0m"
G="\e[38;2;19;255;0m"
Y="\e[33m"
B="\e[34m"
P="\e[35m"
C="\e[36m"
L="\e[37;2m"

bord=$N
excr=$W
eye="\e[38;2;173;255;47m"
cent=$eye
info=$eye

T="$bord [${cent}+${W}${bord}]$excr"
F="$bord [${cent}-${W}${bord}]$excr"

A="${W}$bord [${bol}${Y}!${W}${bord}]$excr"

# Configuración
IP="192.168.101.30"
PORT="5555"
URL_WEBHOOK="http://192.168.101.30:5555/webhook.php"
DIR_PROJECT="/c/src/github/kupload"

SECRETO="1234"

RAMA="main"

if [[ -n $1 ]];then
    RAMA="$1"
fi

# Variables para la lógica del commit
MENSAJE_POR_DEFECTO="Update proyect"
ULTIMO_MENSAJE=""

cd $DIR_PROJECT
clear
        echo -e """${W} DIR:$R $DIR_PROJECT$R

  /\_/\ $W IP:$R $IP
 ( o.o )$W PORT:$R $PORT
  > ^ < $W Branch:$R $RAMA
                """

while true; do
    printf "$W Message:$R " 
    read -r input_usuario

    if [ -z "$input_usuario" ]; then
        if [ -n "$ULTIMO_MENSAJE" ]; then
            MENSAJE_ACTUAL="$ULTIMO_MENSAJE"
        else
            MENSAJE_ACTUAL="$MENSAJE_POR_DEFECTO"
        fi
    else
        MENSAJE_ACTUAL="$input_usuario"
        ULTIMO_MENSAJE="$input_usuario"
    fi

    echo -e "\n$A Preparando Git con el mensaje: '$MENSAJE_ACTUAL'\n"
    
    # Comandos Git
    git add .
    git commit -m "$MENSAJE_ACTUAL"
    git push origin "$RAMA"

    # Verificamos si el push fue exitoso (código de salida 0)
    if [ $? -eq 0 ]; then
        echo -e "\n$A Notificando al servidor para que actualice...\n"
        
        # Hacemos la petición POST con curl
        curl -X POST "$URL_WEBHOOK" -d "secreto=$SECRETO"
        
        echo -e """$Y
  /\_/\  
 ( o.o )$W Todo listo!$Y $MENSAJE_ACTUAL$Y
  > ^ <$W
                """
    else
        echo -e "$E Hubo un problema con git push. No se notificó al servidor."
    fi
    #echo -e "[*] Message: $MENSAJE_ACTUAL\n"
done
