#!/bin/bash
# F3A Microservice - EC2 User Data Script

# Update system
yum update -y

# Install required packages
yum install -y curl wget git docker

# Start Docker
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user

# Install K3s
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Wait for K3s to be ready
sleep 30

# Set up kubectl for ec2-user
mkdir -p /home/ec2-user/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
chown ec2-user:ec2-user /home/ec2-user/.kube/config

# Install Node.js (for local development)
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Create application directory
mkdir -p /opt/f3a-microservice
chown ec2-user:ec2-user /opt/f3a-microservice

# Log completion
echo "$(date): F3A Microservice setup completed" >> /var/log/user-data.log
