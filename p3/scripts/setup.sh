#!/bin/bash

#install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#create k3d cluster
sudo k3d cluster create mycluster -p 8080:80@loadbalancer -p 8888:8888@loadbalancer --k3s-arg "--disable=traefik@server:0"

#Create argocd and dev namespaces
kubectl create namespace argocd
kubectl create namespace dev

# argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl apply -f argocd.yaml

#playground
kubectl apply -f playground.yaml -n dev
