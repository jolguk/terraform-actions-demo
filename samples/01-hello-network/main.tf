# Configure Terraform joannetestmodule1
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "lm-devops-rg"
    storage_account_name = "jolmdevopssa"
    container_name       = "terraform-actions-demo"
    key                  = "02-pr-workflow.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Define local variables
locals {
  prefix = "git-mon-jopr-workflow"

  tags = {
    owner = "terraform"
    demo  = "02-pr-workflow"
    foo   = "bar"
  }
}

# Create a resource group
resource "azurerm_resource_group" "default" {
  name     = "${local.prefix}-rg"
  location = var.location
  tags     = local.tags
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "default" {
  name                = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

# Create a subnet with the virtual network
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.1.0/24"]
}
