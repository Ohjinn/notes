module "net" {
    source              =   "./modules/net"

    prefix              =   var.prefix
    region              =   var.region
    vnet_cidr            =   var.vnet_cidr
    
    subnet_cidr1      =   var.subnet_cidr1
    subnet_cidr2     =   var.subnet_cidr2
    
    admin_access_cidrs  =   var.admin_access_cidrs

    password              =   var.password
}
module "vmss" {
    source              =   "./modules/VMSS"
    depends_on = [module.net]
   prefix              =   var.prefix
    region              =   var.region
    vnet_cidr            =   var.vnet_cidr

    subnet_cidr1      =   var.subnet_cidr1
    subnet_cidr2     =   var.subnet_cidr2

    admin_access_cidrs  =   var.admin_access_cidrs

    password              =   var.password

}