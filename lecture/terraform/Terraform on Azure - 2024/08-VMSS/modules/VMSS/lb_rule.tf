# HTTP LB Rule
resource "azurerm_lb_rule" "lb-rule" {
    loadbalancer_id                = azurerm_lb.lb.id
    name                           = "http"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bep.id]
    frontend_ip_configuration_name = "${var.prefix}-pip"
    probe_id                       = azurerm_lb_probe.lb-probe.id
}

# SSH Inbound NAT Pool
resource "azurerm_lb_inbound_nat_pool" "ssh-nat-pool" {
    loadbalancer_id                = azurerm_lb.lb.id
    name                           = "ssh-natpool"
    protocol                       = "Tcp"
    frontend_port_range_start      = 5000
    frontend_port_range_end        = 5100
    backend_port                   = 22
    frontend_ip_configuration_name = "${var.prefix}-pip"
}