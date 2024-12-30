resource "azurerm_network_interface" "nic2" {
    name                = "${var.prefix}-nic2"
    location            = "${var.region}"
    resource_group_name = "${var.prefix}-RG"

    ip_configuration {
        name                          = "nic2-ip"
        subnet_id                     = azurerm_subnet.subnet1.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.publicip2.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-association2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.this.id
}


