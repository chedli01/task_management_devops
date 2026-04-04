#!/bin/bash
set -e

echo "🚀 Applying Terraform changes..."

cd "$(dirname "$0")/../../environments/kubernetes-prod/04-argocd"

if [ ! -f "tfplan" ]; then
    echo "❌ No plan file found. Run ./scripts-k8s/04-argocd/plan.sh first"
    exit 1
fi

terraform apply tfplan

rm -f tfplan

echo ""
echo "✅ Infrastructure deployed successfully!"
echo ""