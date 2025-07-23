#!/bin/bash
# Iniciar SSH Agent 
eval "$(ssh-agent -s)"

# Adicionar chaves ao agente
echo "Adicionando chave do lucas..."
ssh-add files/keys/lucas_id_rsa 2>/dev/null || echo "Chave lucas já adicionada"

echo " Adicionando chave do jaaziel..."
ssh-add files/keys/jaaziel_id_rsa 2>/dev/null || echo "Chave jaaziel já adicionada"

echo "Chaves adicionadas ao SSH Agent!"
