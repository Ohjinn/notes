resource "azurerm_availability_set" "this" {
 name                         = "${var.prefix}-avset"
 location                     = "${var.region}"
 resource_group_name          = "${var.prefix}-RG"
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
}
