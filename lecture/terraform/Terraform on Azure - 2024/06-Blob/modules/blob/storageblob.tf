
resource "azurerm_storage_blob" "blob" {
  name                   = "test.jpg"
  storage_account_name   = azurerm_storage_account.blob.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "test-sample.jpg"
}
