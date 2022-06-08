# Create App Service Plan
resource "azurerm_app_service_plan" "webapp01-service-plan" {
  name                = "asp-task413-itra"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    # Use Basic tier because it supports HTTPS certificates out-of-the-box
    tier = "Basic"
    size = "B1"
  }
}

# Create App Service WebApp01
resource "azurerm_app_service" "webapp01" {
  name                = "task413-itra-vinnik"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.webapp01-service-plan.id

  # Ensure that WebApp can be accessed only through AppGw01
  site_config {
    ip_restriction {
      ip_address = "${azurerm_public_ip.publicip_appgw.ip_address}/32"
      name       = "AllowInboundAppGw"
      priority   = 100
    }
  }
}
