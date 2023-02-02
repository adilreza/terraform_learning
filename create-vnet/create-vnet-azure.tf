# Terraform Settings Block
/*
took less than 2 minutes to create rg vnet subnet
*/
terraform {

  required_version = ">=1.3.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.41.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "don" {
  name     = "don-rg2"
  location = "eastus"
}

resource "azurerm_virtual_network" "don_vnet" {
  name                = "don-vnet"
  location            = azurerm_resource_group.don.location
  resource_group_name = azurerm_resource_group.don.name
  address_space       = ["10.6.0.0/16"]
}

resource "azurerm_subnet" "mysubnet1" {
  name = "don-k8s-subnet"
  resource_group_name = azurerm_resource_group.don.name
  virtual_network_name = azurerm_virtual_network.don_vnet.name
  address_prefixes = ["10.6.0.0/22"] //10.6.3.255
}

resource "azurerm_subnet" "mysubnet2" {
  name = "don-vm-subnet"
  resource_group_name = azurerm_resource_group.don.name
  virtual_network_name = azurerm_virtual_network.don_vnet.name
  address_prefixes = ["10.6.4.0/24"] //10.6.4.255
}
resource "azurerm_subnet" "mysubnet3" {
  name = "don-db-subnet"
  resource_group_name = azurerm_resource_group.don.name
  virtual_network_name = azurerm_virtual_network.don_vnet.name
  address_prefixes = ["10.6.5.0/24"]
}
