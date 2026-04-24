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

module "acr" {
  source = "./modules/acr"

  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  kubelet_identity    = module.aks.kubelet_identity
}

module "keyvault" {
  source = "./modules/keyvault"

  keyvault_name       = var.keyvault_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  oidc_issuer_url     = module.aks.oidc_issuer_url
}

module "apim" {
  source = "./modules/apim"

  apim_name           = var.apim_name
  location            = var.location
  resource_group_name = module.networking.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  frontend_ip         = var.frontend_ip
}
