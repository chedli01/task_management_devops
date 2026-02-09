#!/bin/bash
set -e

echo "📋 Planning Terraform changes..."

cd "$(dirname "$0")/../environments/prod"

terraform plan -out=tfplan

echo ""
echo "✅ Plan saved to tfplan"
echo ""
echo "To apply these changes, run: ./scripts/apply.sh"