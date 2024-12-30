resource "azurerm_network_interface" "nic2" {
    name                = "${var.prefix}-nic2"
    location            = "${var.region}"
    resource_group_name = "${var.prefix}-RG"

    ip_configuration {
        name                          = "nic2-ip"
        subnet_id                     = azurerm_subnet.subnet2.id
        private_ip_address_allocation = "Dynamic"
#        public_ip_address_id          = azurerm_public_ip.publicip2.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg-association2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backendPool2" {
  network_interface_id    = azurerm_network_interface.nic2.id
  ip_configuration_name   = "nic2-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bep.id
}
resource "azurerm_network_interface_nat_rule_association" "natrule2" {
  network_interface_id  = azurerm_network_interface.nic2.id
  ip_configuration_name = "nic2-ip"
  nat_rule_id           = azurerm_lb_nat_rule.natrule2.id
}
