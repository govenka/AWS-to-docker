#!/bin/bash

# Définissez les variables d'environnement pour votre compte AWS
export AWS_ACCESS_KEY_ID="<votre clé d'accès>"
export AWS_SECRET_ACCESS_KEY="<votre clé secrète>"

# Téléchargez l'image de conteneur de votre service AWS à partir du registre AWS
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <votre ID de registre AWS>.dkr.ecr.us-east-1.amazonaws.com
docker pull <votre ID de registre AWS>.dkr.ecr.us-east-1.amazonaws.com/<nom de votre image>:latest

# Créez un fichier de configuration de service Kubernetes pour votre service
cat > myservice.yml << EOF
apiVersion: v1
kind: Service
metadata:
  name: myservice
  labels:
    app: myservice
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: myservice
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myservice
  template:
    metadata:
      labels:
        app: myservice
    spec:
      containers:
      - name: myservice
        image: <votre ID de registre AWS>.dkr.ecr.us-east-1.amazonaws.com/<nom de votre image>:latest
        ports:
        - containerPort: 80
EOF

# Déployez votre service Kubernetes sur votre cluster K3s
k3s kubectl apply -f myservice.yml
