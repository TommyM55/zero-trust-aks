module "networking" {
  source = "./modules/networking"

  resource_group_name = var.resource_group_name
  location            = var.location
}

module "aks" {
  source = "./modules/aks"

  cluster_name        = var.cluster_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  node_count          = var.node_count
  node_size           = var.node_size
  subnet_id           = module.networking.aks_subnet_id
}
