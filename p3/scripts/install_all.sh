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

# Install ArgoCD in k3d cluster
echo "----------Adding ArgoCD To The K3D Cluster----------"
sudo kubectl apply -n argocd -f ./confs/argocd.yaml # we used this because we've modify the installation script a bit on line 10270 ish
echo "----------Waitting For Pods"
sleep 10
sudo kubectl wait -n argocd --for=condition=Ready pods --all --timeout=180s
echo "----------Configuring ArgoCD-----------"
sudo kubectl apply -f ./confs/ingress.yaml
sudo kubectl apply -n argocd -f ./confs/application.yaml
sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d > argoCD_password.txt
echo "----------ArgoCD Should Be Configured-----------"


# Testing
echo -n "---------Testing install---------"
sudo docker --version
sudo k3d --version
sudo kubectl version
sudo kubectl get all --all-namespaces
sudo k9s