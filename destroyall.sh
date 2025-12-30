#!/bin/bash

# Exit immediately if a command fails
set -e

# Terraform directories in correct destroy order
modules=(
  "90-components"
  # "80-user"   # Backend service
  # "60-catalogue"
  # "70-frontend-alb"    # Frontend ALB (depends on ACM)
  # "60-acm"             # ACM certificates (for ALBs)
  # "50-backend-alb"   # Depends on SGs & VPC
  "40-databases"     # Depends on SGs & subnets
  # "30-vpn"           # Depends on SGs & VPC
  # "10-sg"            # Security groups depend on VPC
  # "20-bastion"
  # "00-vpc"           # VPC last
)

# Loop through each directory and destroy Terraform resources
for dir in "${modules[@]}"
do
  echo "-------------------------------------------"
  echo "Destroying Terraform in $dir..."
  echo "-------------------------------------------"
  terraform -chdir=$dir destroy -auto-approve
done

echo "All specified Terraform modules destroyed successfully."