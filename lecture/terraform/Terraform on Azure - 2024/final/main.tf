# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.region
  name     = random_pet.rg_name.id
}

module "net" {
  source = "./modules/net"

  prefix    = var.prefix
  region    = var.region
  vnet_cidr = var.vnet_cidr

  subnet_cidr = var.subnet_cidr

  admin_access_cidrs = var.admin_access_cidrs

  password = var.password
}

module "aks" {
  source = "./modules/aks"

  azurerm_resource_group = azurerm_resource_group.rg
  vnet_cidr = var.vnet_cidr
  

  subnet_cidr = var.subnet_cidr
  vnet_subnet_id = module.net.subnet_id  # network 모듈에서 출력된 subnet ID 전달
}
