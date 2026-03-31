#!/bin/bash
set -e

RESOURCE_GROUP="task-manager-rg"
LOCATION="switzerlandnorth" 
CLUSTER_NAME="task-manager-cluster"
NODE_COUNT=2 
VM_SIZE="Standard_B2s_v2"

echo "======================================================"
echo "Starting AKS Infrastructure and Application Deployment"
echo "======================================================"

echo "Step 1: Authenticating with Azure..."
az login

echo "Step 2: Creating Resource Group '$RESOURCE_GROUP' in '$LOCATION'..."
az group create --name $RESOURCE_GROUP --location $LOCATION

echo "Step 3: Provisioning AKS Cluster '$CLUSTER_NAME' with $NODE_COUNT '$VM_SIZE' nodes..."
az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $CLUSTER_NAME \
  --node-count $NODE_COUNT \
  --node-vm-size $VM_SIZE \
  --generate-ssh-keys

echo "Step 4: Fetching credentials for kubectl..."
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --overwrite-existing

echo "Step 5: Installing NGINX Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

echo "Waiting for the Ingress Controller to initialize before deploying the app..."
sleep 15

echo "Step 6: Applying Application Manifests via Kustomize..."
kubectl apply -k overlays/prod

echo "======================================================"
echo "Deployment Pipeline Complete!"
echo "======================================================"
echo "Wait a minute or two for Azure to assign a Public IP to your Load Balancer."
echo "Run the following command to find your frontend's new Public IP:"
echo "kubectl get services -n ingress-nginx"