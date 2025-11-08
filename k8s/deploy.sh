#!/bin/bash
# F3A Microservice Kubernetes Deployment Script

set -e

echo "🚀 Deploying F3A Microservice to Kubernetes..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Please install kubectl first."
    exit 1
fi

# Check if K3s is running
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Kubernetes cluster not accessible. Is K3s running?"
    exit 1
fi

# Apply Kubernetes manifests
echo "📦 Creating namespace..."
kubectl apply -f namespace.yaml

echo "🔧 Deploying application..."
kubectl apply -f deployment.yaml

echo "🌐 Creating service..."
kubectl apply -f service.yaml

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/f3a-app -n f3a-microservice

# Show deployment status
echo "✅ Deployment completed!"
echo ""
echo "📊 Deployment Status:"
kubectl get pods -n f3a-microservice
echo ""
kubectl get svc -n f3a-microservice
echo ""

# Get node IP for access
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')
if [ -z "$NODE_IP" ]; then
    NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
fi

echo "🌐 Access URLs:"
echo "   Application: http://$NODE_IP:30080"
echo "   Health Check: http://$NODE_IP:30080/health"
echo ""
echo "🔍 Useful Commands:"
echo "   View logs: kubectl logs -f deployment/f3a-app -n f3a-microservice"
echo "   Scale app: kubectl scale deployment f3a-app --replicas=3 -n f3a-microservice"
echo "   Delete app: kubectl delete namespace f3a-microservice"
