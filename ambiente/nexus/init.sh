#!/bin/bash

server="http://"$ARTIFACT_REPO_HOST:$ARTIFACT_REPO_PORT
username=$ARTIFACT_REPO_USER
password=$ARTIFACT_REPO_PASSWORD

echo "Aguardando conclusão da instalação do Nexus..."
until curl --fail --insecure $server > /dev/null; do   
   echo "Aguardando conclusão de instalação do Nexus"
   sleep 10   
done

oldPassword="$(cat /nexus-data/admin.password)"
changePasswordRest=$server"/service/rest/v1/security/users/"$username"/change-password" 

echo "Alteração da senha padrão do administrador"
curl -v -X PUT -u $username:$oldPassword --header "Content-Type: text/plain" $changePasswordRest -d $password

cd /deploy-config/nexus

echo "Liberação de acesso anônimo"
echo "====================================================="
curl -v -X PUT -u $username:$password --header "accept: application/json" --header "Content-Type: application/json" $server"/service/rest/v1/security/anonymous" -d @enableAnonymous.json

echo "Inclusão de proxy npm"
echo "====================================================="
curl -v -X POST -u $username:$password --header "Content-Type: application/json" $server"/service/rest/v1/repositories/npm/proxy" -d @npmproxy.json

echo "Ajustes de pós instalação concluídos"