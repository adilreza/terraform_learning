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

data "azurerm_resource_group" "rg-pre-existing" {
  name     = "don-rg2"
}

data "azurerm_subnet" "mysubnet2" {
  name = "don-vm-subnet"
  virtual_network_name = "don-vnet"
  resource_group_name = data.azurerm_resource_group.rg-pre-existing.name
}

resource "azurerm_public_ip" "myfirstpubip" {
  name = "MyPublicIP-don"
  location = data.azurerm_resource_group.rg-pre-existing.location
  resource_group_name = data.azurerm_resource_group.rg-pre-existing.name
  allocation_method = "Static"
}

# create a network interface
resource "azurerm_network_interface" "don-ni" {
  name                = "don-nic"
  location            = data.azurerm_resource_group.rg-pre-existing.location
  resource_group_name = data.azurerm_resource_group.rg-pre-existing.name

  ip_configuration {
    name                          = "firstvm-config"
    subnet_id                     = data.azurerm_subnet.mysubnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.myfirstpubip.id
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = data.azurerm_resource_group.rg-pre-existing.location
  resource_group_name = data.azurerm_resource_group.rg-pre-existing.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_linux_virtual_machine" "don-vm" {
  name = "don-vm"
  resource_group_name = data.azurerm_resource_group.rg-pre-existing.name
  location = data.azurerm_resource_group.rg-pre-existing.location
  size = "Standard_B1s" //1,1
  admin_username = "ubuntu"
  admin_password = "*****"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.don-ni.id
  ]
  

  source_image_reference {
    publisher = "Canonical" // Canonical is the publisher of official Ubuntu images on Microsoft Azure
    offer     = "UbuntuServer" // az vm image list --output table
    sku       = "18.04-LTS"
    version   = "latest"
  }

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


}


resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.don-ni.id
  network_security_group_id = azurerm_network_security_group.example.id
}