#!/usr/bin/env bash

set -e

echo "Initializing Terraform..."
terraform init

echo "Selecting Terraform Workspace ($DEPLOY_WORKSPACE)..."
terraform workspace new dev
terraform workspace new test
terraform workspace new prod
terraform workspace select $DEPLOY_WORKSPACE

echo "Validating Terraform Format..."
terraform fmt -check

echo "Planning Terraform Deployment..."
terraform plan

echo "Applying Terraform Deployment..."
terraform apply -auto-approve

terraform workspace select test

echo "Validating Terraform Format..."
terraform fmt -check

echo "Planning Terraform Deployment..."
terraform plan

echo "Applying Terraform Deployment..."
terraform apply -auto-approve

terraform workspace select prod

echo "Validating Terraform Format..."
terraform fmt -check

echo "Planning Terraform Deployment..."
terraform plan

echo "Applying Terraform Deployment..."
terraform apply -auto-approve