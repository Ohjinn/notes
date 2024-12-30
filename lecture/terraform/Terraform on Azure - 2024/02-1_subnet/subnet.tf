# Subnet1
resource "azurerm_subnet" "subnet1" {
    count = 2
    name = "${var.prefix}-subnet${count.index}"
    resource_group_name = azurerm_resource_group.this.name
    virtual_network_name = azurerm_virtual_network.this.name
    address_prefixes = ["${var.subnet_prefix}${count.index}${var.subnet_suffix}"]
}
