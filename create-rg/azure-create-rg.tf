# Terraform Settings Block
terraform {
  required_version = ">=1.3.6"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create Resource Group
resource "azurerm_resource_group" "don_rg" {
    location = "eastus"
    name = "don-rg"
    
    tags = {
      "name" = "don-free"
    }
}
