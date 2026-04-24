resource "azurerm_api_management" "main" {
  name                = var.apim_name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = "Consumption_0"
}

resource "azurerm_api_management_api" "frontend" {
  name                = "frontend-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Zero Trust Frontend"
  path                = ""
  protocols           = ["https"]
  subscription_required = false

  import {
    content_format = "openapi"
    content_value  = <<OPENAPI
openapi: 3.0.0
info:
  title: Zero Trust Frontend
  version: 1.0.0
paths:
  /:
    get:
      operationId: get-home
      responses:
        '200':
          description: OK
  /health:
    get:
      operationId: get-health
      responses:
        '200':
          description: OK
  /place-order:
    post:
      operationId: place-order
      responses:
        '200':
          description: OK
OPENAPI
  }
}

resource "azurerm_api_management_backend" "frontend" {
  name                = "frontend-backend"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "http://${var.frontend_ip}"
}

resource "azurerm_api_management_api_policy" "frontend" {
  api_name            = azurerm_api_management_api.frontend.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service backend-id="frontend-backend" />
    <rate-limit calls="100" renewal-period="60" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}
