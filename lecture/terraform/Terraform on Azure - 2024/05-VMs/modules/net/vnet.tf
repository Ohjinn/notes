resource "azurerm_virtual_network" "this" {
	name 			= "${var.prefix}-vnet"
	address_space 		= ["${var.vnet_cidr}"]
	location 			= azurerm_resource_group.this.location
	resource_group_name	= azurerm_resource_group.this.name
}
