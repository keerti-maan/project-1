
resource "azuread_user" "firstuser" {
  user_principal_name = "keerti.maan@xyz.com"
  display_name        = "Keerti Maan"
  password            = "fabsfhbahjfbg"
}

resource "azuread_user" "seconduser" {
  user_principal_name   = "ibrahim.ozbekler@xyz.com"
  display_name          = "Ibrahim Ozbekler"
  password              = "aoqoiforejwvk"
  force_password_change = "true"
}

resource "aws_iam_user" "the-accounts" {
  for_each = toset(var.users)
  name     = each.value
}

resource "aws_s3_bucket" "bucket" {
  bucket = "bucket - ${count.index}"
  count  = var.number_of_bucket

  tags = {
    environment = "Prod"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "FirstResourceGroup"
  location = var.location
  tags = {
    environment = "Dev"
  }
}
resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = ["10.0.2.0/24"]

}

resource "azurerm_network_interface" "interface" {
  name                = "nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "linux" {
  name                = "linuxvm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.interface.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  tags = {
    name = "linux virtual machine"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = "storage123"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    name        = "sa"
    environment = "Dev"
  }
}