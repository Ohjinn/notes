
resource "azurerm_storage_container" "container" {
  name                  = "${var.prefix}-content"
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "container"
}
