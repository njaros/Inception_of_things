#!/bin/bash

# General Install
echo "----------Updating Binary--------"
sudo apt-get update

# Install Docker
echo "-----------Installing Docker---------"
sudo curl -fsSL https://get.docker.com | sh -
echo "-----------Enabling Docker And ContainerD Service---------"
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo systemctl start docker
echo "-----------Docker Should Be Ready To Use----------"

# Install K3D
echo "-----------Installing K3D-----------"
sudo curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash
echo "-----------Creating K3D Cluster-----------"
sudo k3d cluster create -p "8080:80" jrinnacluster

# Install Kubectl
echo "-----------Installing Kubectl-----------"
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
echo "-----------Moving Kubectl------------"
sudo mv ./kubectl /usr/local/bin

# Creating namespace
echo "----------Creating NameSpace------------"
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl create namespace gitlab


# Install ArgoCD in k3d cluster
echo "----------Adding ArgoCD To The K3D Cluster----------"
sudo kubectl apply -n argocd -f ./confs/argocd.yaml # we used this because we've modify the installation script a bit on line 10242 ish
echo "----------Waitting For Pods"
sleep 10
sudo kubectl wait -n argocd --for=condition=Ready pods --all --timeout=180s
echo "----------Configuring ArgoCD-----------"
sudo kubectl apply -f ./confs/ingress.yaml
sudo kubectl apply -n argocd -f ./confs/application.yaml
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d > argoCD_password.txt
echo "----------ArgoCD Should Be Configured-----------"

# Installing Helm
echo "----------Installing Helm-----------"
sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Installing GitLab
echo "----------Installing Gitlab With Helm-----------"
sudo helm repo add gitlab https://charts.gitlab.io # telling helm were to look
sudo helm repo update # telling helm to get the latest info about it's repository (the new one we just addded)
sudo helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=localhost \
  --set global.ingress.configureCertmanager=false \
  --set global.hosts.https=false \
  --set global.ingress.enabled=true \
  --set minio.enable=false \
  --set certmanager.install=false \
  --set gitlab-runner.install=false \

echo "----------Waitting For Gitlab Pod To Be Ready-----------"
sleep 10
sudo kubectl wait -n gitlab --for=condition=Ready pods --all --timeout=300s
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 -d > gitlab_password.txt
echo "----------Gitlab Should Be Ready-----------"

# Testing
echo "---------Testing install---------"
sudo kubectl get all --all-namespaces
sudo kubectl version
sudo k3d --version
sudo docker --version
sudo helm version
sudo k9s