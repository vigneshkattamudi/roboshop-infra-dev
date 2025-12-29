#!/bin/bash

# Exit immediately if a command fails
set -e

# Terraform directories in correct creation order
modules=(
  "00-vpc"            # VPC first
  "10-sg"             # Depends on VPC
  "30-vpn"            # Depends on SGs & VPC
  "40-databases"      # Depends on SGs & subnets
  "50-backend-alb"    # Depends on SGs & VPC
  "60-catalogue"  # Depends on ALB & backend infra
)

# Loop through each directory and apply Terraform resources
for dir in "${modules[@]}"
do
  echo "-------------------------------------------"
  echo "Applying Terraform in $dir..."
  echo "-------------------------------------------"

  terraform -chdir=$dir init -upgrade
  terraform -chdir=$dir apply -auto-approve
done

echo "All specified Terraform modules applied successfully."
