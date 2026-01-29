#!/bin/bash
set -e

# Cria /app/storage se não existir e corrige permissões
 # ajuste para o UID do seu user Rails (verifique com whoami no container)
chmod -R 755 /app/storage || true

# Executa o comando original
exec "$@"