resource "azurerm_lb_nat_rule" "natrule2" {
    resource_group_name            = "${var.prefix}-RG"
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "web2SSH"
  protocol                       = "Tcp"
  frontend_port                  = 50002
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.prefix}-pip"
}
