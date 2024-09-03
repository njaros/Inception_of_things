# removing k3d
echo "uninstalling K3d"
sudo k3d cluster delete --all
sudo rm $(which k3d)
sudo rm -rf ~/.k3d

# stopping and removing all files linked to Docker
sudo  apt remove --purge -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo rm -rf -y /var/lib/docker /etc/docker
sudo groupdel docker
sudo rm -rf /var/run/docker.sock

# clean up any leftover dependencies
sudo apt -y autoremove

# removing kubectl
echo "Deleting kubectl"
sudo rm -rf /usr/local/bin/kubectl
sudo rm -rf ~/.kube

# delete useless files
sudo rm -f ./argocd_password.txt
echo "argocd_password.txt deleted"
sudo rm -f ./get-docker.sh
echo "Docker installation script deleted"