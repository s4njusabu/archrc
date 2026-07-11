#!/bin/bash
set -e

# Install dependencies
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl gpg

# Add Kubernetes apt keyring
sudo mkdir -p /etc/apt/keyrings

K8S_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt | grep -oP 'v\d+\.\d+')

curl -fsSL https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/Release.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes apt repo
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/deb/ /" | \
  sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install kubelet, kubeadm, kubectl
sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# Hold versions so apt upgrade doesn't break the cluster
sudo apt-mark hold kubelet kubeadm kubectl

echo "kubeadm/kubelet/kubectl installed: $(kubeadm version -o short)"
