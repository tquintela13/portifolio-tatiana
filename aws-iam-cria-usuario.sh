#!/bin/bash

# Proposito: Automatiza a criação de usuários na AWS
# Utilizacao: ./aws-iam-cria-usuario.sh <arquivo.csv>
# Formato: usuario;grupo;senha

INPUT=$1

[ ! -f "$INPUT" ] && { echo "$INPUT arquivo nao encontrado"; exit 99; }

OLDIFS=$IFS
IFS=';'

while read -r usuario grupo senha
do
    # Ignora cabeçalho
    if [ "$usuario" != "usuarios" ]; then

        # Remove espaços extras
        usuario=$(echo "$usuario" | xargs)
        grupo=$(echo "$grupo" | xargs)
        senha=$(echo "$senha" | xargs)

        echo "Criando usuário: $usuario"

        aws iam create-user --user-name "$usuario"
        aws iam create-login-profile --password-reset-required \
            --user-name "$usuario" \
            --password "$senha"

        aws iam add-user-to-group \
            --group-name "$grupo" \
            --user-name "$usuario"
    fi

done < "$INPUT"

IFS=$OLDIFS
