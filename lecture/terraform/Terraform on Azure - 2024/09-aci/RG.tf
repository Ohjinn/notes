# ResourceGroup
resource "azurerm_resource_group" "this" {
    name     = "${var.prefix}-RG"
    location = "${var.region}"

    tags = {
        environment = "Terraform Demo"
    }
}
