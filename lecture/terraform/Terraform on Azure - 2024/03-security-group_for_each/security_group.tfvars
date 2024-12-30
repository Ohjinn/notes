prefix      =       "user09"
region      =       "koreacentral"
vnet_cidr    =       "10.0.0.0/16"
subnet_cidr1     =       "10.0.1.0/24"
subnet_cidr2     =       "10.0.2.0/24"

admin_access_cidrs           = "121.166.132.10"

security_rules = [
    {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "0.0.0.0/0"
        destination_address_prefix = "*"
    },
    {
        name                       = "HTTP"
        priority                   = 2001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
]