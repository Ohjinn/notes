resource "azurerm_lb" "lb" {
  name                  = "${var.prefix}-lb"
    location            = "${var.region}"
    resource_group_name = "${var.prefix}-RG"

  frontend_ip_configuration {
        name = "${var.prefix}-pip"
  public_ip_address_id = azurerm_public_ip.publicip1.id
  }
}
