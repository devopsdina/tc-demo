terraform {
   required_version = ">=1.0"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
 }
#Create azure resource group
resource "azurerm_resource_group" "tc-demo" {
  name     = "tc-demo"
  location = "${var.location}"
}

#Create azure storage account
resource "azurerm_storage_account" "tc-demo-sa" {
  name                     = "tcdemosa"
  resource_group_name      = azurerm_resource_group.tc-demo.name
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
#Create virtual network for the VM
resource "azurerm_virtual_network" "tc-demo-vnet" {
  name                = "tc-demo-vnet"
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.tc-demo.name
}

#Create subnet to the virtual network
resource "azurerm_subnet" "subnet" {
  name                 = "tc-demo-subnet"
  virtual_network_name = azurerm_virtual_network.tc-demo-vnet.name
  resource_group_name  = azurerm_resource_group.tc-demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Create public ip
resource "azurerm_public_ip" "tc-demo-pip" {
  name                = "tc-demo-pip"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.tc-demo.name
  allocation_method   = "Static"
}

#Create Network security group
resource "azurerm_network_security_group" "tc-demo-sg" {
  name                = "tc-demo-sg"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.tc-demo.name

  security_rule {
    name                       = "HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Create Network interface
resource "azurerm_network_interface" "tc-demo-nic" {
  name                = "tc-demo-nic"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.tc-demo.name

  ip_configuration {
    name                          = "tc-demo-ipconfig"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tc-demo-pip.id
  }
}

resource "azurerm_virtual_machine" "tc-demo-site" {
  name                = "tc-demo-site"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.tc-demo.name
  vm_size             = "Standard_DS1_v2"

  network_interface_ids         = ["${azurerm_network_interface.tc-demo-nic.id}"]
  delete_os_disk_on_termination = "true"

  storage_image_reference {
     publisher = "Canonical"
     offer     = "UbuntuServer"
     sku       = "16.04-LTS"
     version   = "latest"
  }

  storage_os_disk {
    name              = "tc-demo-osdisk"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "tc-demo"
    admin_username = "${var.ADMIN_USERNAME}"
    admin_password = "${var.ADMIN_PASSWORD}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>Hello from Azure! Terraform cloud demo!</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.tc-demo-pip.fqdn
      user        = "${var.ADMIN_USERNAME}"
      password    = "${var.ADMIN_PASSWORD}"
    }
  }
}

output "instance_ips" {
  value = azurerm_public_ip.tc-demo-pip.ip_address
}