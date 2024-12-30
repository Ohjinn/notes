# ResourceGroup
resource "azurerm_resource_group" "this" {
  name     = "${var.prefix}-RG2"
  location = var.region

  tags = {
    environment = "Terraform Demo"
  }
}
