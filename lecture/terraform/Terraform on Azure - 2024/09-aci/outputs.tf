output "container_public_ip" {
  description = "Public IP address of the aci"
  value       = azurerm_container_group.this.ip_address
}