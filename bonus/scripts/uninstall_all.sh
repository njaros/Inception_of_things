#!/bin/bash

sudo rm -rf password.txt
sudo rm -rf gitlab_password.txt

# ---------------------------------------------------------------------------- #
#                                Helm Uninstall                                #
# ---------------------------------------------------------------------------- #

# Capture the real user's home directory
REAL_HOME=$(eval echo ~${SUDO_USER})

# Remove the helm binary
sudo rm -rf /usr/local/bin/helm

# Remove Helm cache
sudo rm -rf "$REAL_HOME/.cache/helm"

# Remove Helm configuration
sudo rm -rf "$REAL_HOME/.config/helm"

# Remove Helm data
sudo rm -rf "$REAL_HOME/.local/share/helm"

# Remove any Helm plugins (if applicable)
sudo rm -rf "$REAL_HOME/.helm"

# ---------------------------------------------------------------------------- #
#                              K3D Uninstallation                              #
# ---------------------------------------------------------------------------- #

# Delete all k3d clusters
echo "Deleting all k3d clusters..."
sudo k3d cluster delete --all

# Remove the k3d binary
echo "Removing k3d binary..."
sudo rm $(which k3d)

# Remove k3d configuration files
echo "Removing k3d configuration files..."
sudo rm -rf ~/.k3d

echo "k3d uninstallation and cleanup completed."

# ---------------------------------------------------------------------------- #
#                               Uninstall Docker                               #
# ---------------------------------------------------------------------------- #

# Stop all running containers
sudo docker stop $(sudo docker ps -aq)

# Remove all containers image volumes etc
sudo docker system prune -af --volumes

# Uninstall Docker packages
sudo apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Remove Docker directories
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# Remove Docker GPG key and repository
sudo rm /etc/apt/keyrings/docker.gpg
sudo rm /etc/apt/sources.list.d/docker.list

# Auto-remove any leftover dependencies
sudo apt-get autoremove -y

# Clean up package cache
sudo apt-get clean

# ---------------------------------------------------------------------------- #
#                               Kubectl Uninstall                              #
# ---------------------------------------------------------------------------- #

# remove the binary
sudo rm /usr/local/bin/kubectl

# remove the config directory
sudo rm -rf ~/.kube

# remove alias
sed -i '/alias kubectl/d' ~/.bashrc
source ~/.bashrc

# ---------------------------------------------------------------------------- #
#                               Testing Uninstall                              #
# ---------------------------------------------------------------------------- #

echo "---------Testing uninstall---------"
sudo kubectl get all --all-namespaces
sudo kubectl version
sudo k3d --version
sudo docker --version
sudo helm version
echo "everything is uninstall"