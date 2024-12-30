variable "prefix" {}
variable "region" {}
variable "vnet_cidr" {}

variable "subnet_cidr1" {}
variable "subnet_cidr2" {}

variable "admin_access_cidrs" {}

variable "security_rules" {
    type = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
    }))
    description = "A list of security rules to apply to the Network Security Group."
}
