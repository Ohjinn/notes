
resource "azurerm_storage_account" "blob" {
  name                     = "${var.prefix}diagstorageblob"
  resource_group_name      = "${var.prefix}-RG2"
  location                 = var.region
  account_replication_type = "LRS"
  account_tier             = "Standard"

  tags = {
    environment = "Terraform Demo"
  }
}

