## password I'll use for this project ##

iotiotiot

## my github link for access the playground ##

https://github.com/njaros/iot_repo_p3.git

## given by source ##

k3d cluster create {name} -> creates a kubernetes cluster in a docker container + set up kube config file

kubectl port-forward svc/argocd-server -n argocd 8080:443 -> open a port to access argocd server with a browser

argocd admin initial-password -n argocd -> recover initial password of argocd-server for admin

argocd login [server-url] -> connect to a running argocd-server. to get server-url, type "docker ps"

argocd update-password -> to change the init-password

## to create an app managed by argocd in a namespace ##

1/ kubectl config set-context --current --namespace=argocd -> tutorial say to do it first
2/ argocd app create playground --repo https://github.com/njaros/iot_repo_p3.git --path playground --dest-server https://kubernetes.default.svc --dest-namespace dev

## acceed to the app in browser ##

Only usefull to debug.

kubectl port-forward svc/{appname} -n {namespace} 9999:80

## given by chat-GPT ##

kubectl config current-context -> gives us the name of the cluster kubectl is focusing

kubectl get nodes -> lists the nodes running in the cluster

export KUBECONFIG=$(k3d kubeconfig write p3) -> creates the config file at /${HOME}/.kube/config
                                                useless if k3d cluster create did his job correctly

## given by Nana ##

sources : https://www.youtube.com/watch?v=s_o8dwzRlu4

kubectl get nodes -o wide -> to recover the ip address of the app deployed

kubectl get svc -n dev -> to recover the port of the service of type NodePort in our namespace "dev"

when all is deployed: enter on brower or curl : {INTERNAL_IP of node control panel/master}:{svc-port}