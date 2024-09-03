#!/bin/bash

#install docker
sudo apt update -q
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

#install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d cluster create -p "8080:80" mycluster 

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin

# Create namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

# install argocd configuration ands confs files
sudo kubectl apply -n argocd -f ./confs/argocd-installation.yaml
sudo kubectl apply -n argocd -f ./confs/application.yaml
sleep 5
sudo kubectl wait -n argocd --for=condition=Ready pods --all --timeout=60s
sudo kubectl apply -f ./confs/ingress.yaml
sleep 5
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd_password.txt