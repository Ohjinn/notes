module "net" {
  source = "./modules/net"

  prefix    = var.prefix
  region    = var.region
  vnet_cidr = var.vnet_cidr

}
module "blob" {
  source     = "./modules/blob"
  depends_on = [module.net]
  prefix     = var.prefix
  region     = var.region
  vnet_cidr  = var.vnet_cidr
}
