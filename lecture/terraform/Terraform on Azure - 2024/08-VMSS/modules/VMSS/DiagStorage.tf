resource "azurerm_storage_account" "this" {
    name                = "${var.prefix}diagstorage"
    resource_group_name = "${var.prefix}-RG"
    location = "${var.region}"
    account_replication_type = "LRS"
    account_tier = "Standard"

    tags = {
        environment = "Terraform Demo"
    }
}
