#!/bin/bash
set -e

# Update system
yum update -y

# Install required packages
yum install -y yum-utils unzip

# Add HashiCorp official repository
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install Terraform
yum install -y terraform

# Verify installation
terraform version
