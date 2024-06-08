#!/bin/bash
# Update the package list
sudo apt-get update -y

sudo apt install net-tools -y

# Disable swap and prevent it from being reactivated
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Load necessary kernel modules
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Set up required sysctl params, these persist across reboots
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install required packages
sudo apt-get install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker's official GPG key and set up the stable repository
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package list again after adding Docker repository
sudo apt-get update -y

# Install containerd
sudo apt-get install -y containerd.io

# Generate default containerd configuration file
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

# Set SystemdCgroup to true
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

# Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

# Update the package list
sudo apt-get update -y

# Install necessary packages for Kubernetes
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Add Kubernetes GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the package list again after adding Kubernetes repository
sudo apt-get update -y

# Install Kubernetes components
sudo apt-get install -y kubelet kubeadm kubectl

# Mark the Kubernetes packages to hold
sudo apt-mark hold kubelet kubeadm kubectl

# Enable and restart kubelet
sudo systemctl enable --now kubelet
sudo systemctl restart kubelet

#### Need to configure mater node first and change the join command below ###

kubeadm join 27.0.1.140:6443 --token 17stt9.bquwkfpm2ztluwr7 \
        --discovery-token-ca-cert-hash sha256:80e35ce80ecd3a83f1b76caa4494164ec2f9846017b4124562600654b3877637

sudo systemctl restart kubelet
sudo systemctl restart kubelet



echo "Worker node setup completed successfully."
