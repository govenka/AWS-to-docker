#!/bin/bash

# Définissez les variables d'environnement pour votre compte AWS
export AWS_ACCESS_KEY_ID="<votre clé d'accès>"
export AWS_SECRET_ACCESS_KEY="<votre clé secrète>"

# Téléchargez l'image de conteneur de votre service AWS à partir du registre AWS
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <votre ID de registre AWS>.dkr.ecr.us-east-1.amazonaws.com
docker pull <votre ID de registre AWS>.dkr.ecr.us-east-1.amazonaws.com/<nom de votre image>:latest

# Créez un fichier de configuration de service Swarm pour votre service
cat > myservice.yml << EOF
version: "3.7"
services:
  myservice:
    image: <votre ID de registre AWS>.dkr.ecr.us-east-1.amazonaws.com/<nom de votre image>:latest
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == worker
EOF

# Déployez votre service Swarm sur votre cluster
docker stack deploy -c myservice.yml myservice



