resource "azurerm_lb_nat_rule" "natrule1" {
  resource_group_name            = "${var.prefix}-RG"
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "web1SSH"
  protocol                       = "Tcp"
  frontend_port                  = 50001
  backend_port                   = 22
  frontend_ip_configuration_name = "${var.prefix}-pip"
}
