#stopping and removing all files linked to Docker
sudo systemctl stop docker
docker system prune -af --volumes
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo groupdel docker
sudo rm -rf /etc/docker
sudo rm -rf ~/.docker
sudo rm -rf /usr/local/bin/docker-compose
sudo rm -rf /usr/local/bin/docker-machine
sudo rm -rf /usr/bin/docker

# update the package cache
sudo apt update

# removing k3d
k3d cluster delete -a
sudo rm $(which k3d)
echo "K3D uninstalled"

# removing kubectl 
sudo rm /usr/local/bin/kubectl
sudo rm -rf ~/.kube

# delete password
sudo rm /home/jereverd/Documents/Inception_of_things/p3/argocd_password.txt
