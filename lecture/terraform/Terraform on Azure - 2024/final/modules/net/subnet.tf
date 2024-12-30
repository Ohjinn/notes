# Subnet1
resource "azurerm_subnet" "subnet" {
    name = "${var.prefix}-subnet"
    resource_group_name = "${var.prefix}-RSGR"
    virtual_network_name = "${var.prefix}-vnet"
    address_prefixes = ["${var.subnet_cidr}"]
}
