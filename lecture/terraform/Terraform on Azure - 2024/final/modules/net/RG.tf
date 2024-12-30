# ResourceGroup
resource "azurerm_resource_group" "this" {
    name     = "${var.prefix}-RSGR"
    location = "${var.region}"

    tags = {
        environment = "Terraform Demo"
    }
}
