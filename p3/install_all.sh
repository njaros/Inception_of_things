#!/bin/bash

# General Install
echo "----------Updating Binary--------"
sudo apt-get update

# Install Docker
echo "-----------Installing Docker---------"
curl -fsSL https://get.docker.com | sh -
echo "-----------Enabling Docker And ContainerD Service---------"
sudo systemctl enable --now docker.service
sudo systemctl enable --now containerd.service
sudo systemctl start docker
echo "-----------Docker Should Be Ready To Use----------"

# Install K3D
echo "-----------Installing K3D-----------"
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | sudo bash
echo "-----------Creating K3D Cluster-----------"
# k3d cluster create jrinnacluster
k3d cluster create -p "8080:80" jrinnacluster

# Install Kubectl
echo "-----------Installing Kubectl-----------"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
echo "-----------Moving Kubectl------------"
sudo mv ./kubectl /usr/local/bin

# Creating namespace for ?????
echo "----------Creating NameSpace------------"
kubectl create namespace argocd
kubectl create namespace dev

# Install ArgoCD in k3d cluster
echo "----------Adding ArgoCD To The K3D Cluster----------"
# kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -n argocd -f ./argocd.yaml # we used this because we've modify the installation script a bit on line 10270 ish
echo "----------Waitting For Pods"
sleep 10
kubectl wait -n argocd --for=condition=Ready pods --all --timeout=120s
echo "----------Port Forwarding-----------"
# kubectl port-forward -n argocd service/argocd-server 8042:80 & # also work but we wanted to use the ingress way
kubectl apply -n argocd -f ./ingress.yaml


# Testing
echo -n "---------Testing install---------"
sudo docker --version
sudo k3d --version
sudo kubectl version
sudo kubectl get all --all-namespaces