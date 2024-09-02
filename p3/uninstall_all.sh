#!/bin/bash

# ---------------------------------------------------------------------------- #
#                              K3D Uninstallation                              #
# ---------------------------------------------------------------------------- #

# Delete all k3d clusters
echo "Deleting all k3d clusters..."
k3d cluster delete --all

# Remove the k3d binary
echo "Removing k3d binary..."
sudo rm $(which k3d)

# Remove k3d configuration files
echo "Removing k3d configuration files..."
rm -rf ~/.k3d

echo "k3d uninstallation and cleanup completed."

# ---------------------------------------------------------------------------- #
#                               Uninstall Docker                               #
# ---------------------------------------------------------------------------- #

# Stop all running containers
sudo docker stop $(sudo docker ps -aq)

# Remove all containers
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
rm -rf ~/.kube

# remove alias
sed -i '/alias kubectl/d' ~/.bashrc
source ~/.bashrc
