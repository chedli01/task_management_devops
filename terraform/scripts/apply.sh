#!/bin/bash
set -e

echo "🚀 Applying Terraform changes..."

cd "$(dirname "$0")/../environments/prod"

if [ ! -f "tfplan" ]; then
    echo "❌ No plan file found. Run ./scripts/plan.sh first"
    exit 1
fi

terraform apply tfplan

rm -f tfplan

echo ""
echo "✅ Infrastructure deployed successfully!"
echo ""
echo "Getting VM details..."
terraform output