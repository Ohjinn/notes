variable "prefix" {}
variable "region" {}
variable "vnet_cidr" {}
variable "subnet_cidrs" {
  type    = list(string)
}