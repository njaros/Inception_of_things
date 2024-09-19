#!/bin/bash

# install docker
sudo apt update -q
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# install K3D
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo k3d cluster create -p 8080:80 mycluster 

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv ./kubectl /usr/local/bin


# Create namespaces
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl create namespace gitlab

# install argocd configuration ands confs files
sudo kubectl apply -n argocd -f ./confs/argocd-installation.yaml
sudo kubectl apply -n argocd -f ./confs/application.yaml
sleep 5
sudo kubectl wait -n argocd --for=condition=Ready pods --all --timeout=60s
sudo kubectl apply -f ./confs/ingress.yaml
sleep 5
sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd_password.txt

# install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Add the GitLab Helm repository
sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update

# Install GitLab using Helm
sudo helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  -f ./confs/gitlab-values.yaml 
sudo kubectl wait -n gitlab --for=condition=available deployment --all --timeout=-1s

#Get initial root password
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode > gitlab_password.txt