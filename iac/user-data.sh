#!/bin/bash
# F3A Microservice - EC2 User Data Script with Full Deployment

set -e

# Update system
yum update -y

# Install required packages
yum install -y curl wget git docker gcc-c++ make

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

# Install Node.js
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Clone and deploy microservice
cd /home/ec2-user
git clone https://github.com/considerable/f3a-microservice.git
chown -R ec2-user:ec2-user f3a-microservice

# Pull Docker image from GitHub Container Registry
cd f3a-microservice
docker pull ghcr.io/considerable/f3a-microservice:latest

# Import image to K3s
k3s ctr images import <(docker save ghcr.io/considerable/f3a-microservice:latest)

# Deploy to K3s
cd ../k8s
k3s kubectl apply -f namespace.yaml
k3s kubectl apply -f deployment.yaml
k3s kubectl apply -f service.yaml

# Wait for deployment
k3s kubectl wait --for=condition=available --timeout=300s deployment/f3a-app -n f3a-microservice

# Log deployment status
echo "=== F3A Microservice Deployment Complete ===" > /var/log/user-data.log
echo "Timestamp: $(date)" >> /var/log/user-data.log
echo "" >> /var/log/user-data.log
echo "Pods:" >> /var/log/user-data.log
k3s kubectl get pods -n f3a-microservice >> /var/log/user-data.log
echo "" >> /var/log/user-data.log
echo "Services:" >> /var/log/user-data.log
k3s kubectl get svc -n f3a-microservice >> /var/log/user-data.log
echo "" >> /var/log/user-data.log
echo "Test: curl http://localhost:30080/api/brands" >> /var/log/user-data.log
