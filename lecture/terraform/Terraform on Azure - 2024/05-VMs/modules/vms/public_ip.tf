resource "azurerm_public_ip" "publicip1" {
name                = "${var.prefix}-publicip1"
location            = "${var.region}"
resource_group_name = "${var.prefix}-RG"
allocation_method   = "Static"
domain_name_label   = "${var.prefix}-rgdomain1"

        tags = {
                environment = "staging"
        }

}

resource "azurerm_public_ip" "publicip2" {
name                = "${var.prefix}-publicip2"
location            = "${var.region}"
resource_group_name = "${var.prefix}-RG"
allocation_method   = "Static"
domain_name_label   = "${var.prefix}-rgdomain2"

        tags = {
                environment = "staging"
        }

}
