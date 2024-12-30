resource "azurerm_subnet" "subnet" {
  count = length(var.subnet_cidrs)
  
  name                 = "${var.prefix}-subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidrs[count.index]]
}