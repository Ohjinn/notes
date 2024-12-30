# Subnet1
resource "azurerm_subnet" "subnet1" {
    name = "${var.prefix}-subnet1"
    resource_group_name = "${var.prefix}-RG"
    virtual_network_name = "${var.prefix}-vnet"
    address_prefixes = ["${var.subnet_cidr1}"]
}

# Subnet2
resource "azurerm_subnet" "subnet2" {
    name = "${var.prefix}-subnet2"
    resource_group_name = "${var.prefix}-RG"
    virtual_network_name = "${var.prefix}-vnet"
    address_prefixes = ["${var.subnet_cidr2}"]
}
