#!/bin/bash
set -e

# Disable swap now, and persist across reboot regardless of fstab formatting
# (matches on fstab's 3rd column = "swap", not on spacing or device path)
sudo swapoff -a
sudo cp /etc/fstab /etc/fstab.bak
sudo awk '{
  line = $0
  sub(/^[[:space:]]*/, "", line)
  if (line ~ /^#/) { print $0; next }
  if ($3 == "swap") { print "#" $0; next }
  print $0
}' /etc/fstab.bak | sudo tee /etc/fstab > /dev/null

# Load required kernel modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Persist modules after reboot
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

# Kubernetes networking settings
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

# Apply sysctl settings
sudo sysctl --system

# Install containerd
sudo apt update
sudo apt install -y containerd

# Generate default containerd config
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Enable systemd cgroups
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' \
  /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# Verify
sudo systemctl is-active --quiet containerd && echo "containerd running"
