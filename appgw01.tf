# Create Application Gateway
resource "azurerm_application_gateway" "appgw01" {
  name                = "AppGw01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "AppGwSubnet"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "frontend_port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend_config"
    public_ip_address_id = azurerm_public_ip.publicip_appgw.id
  }

  backend_address_pool {
    name  = "WebApp01"
    fqdns = [azurerm_app_service.webapp01.default_site_hostname]
  }

  http_listener {
    name                           = "listener"
    frontend_ip_configuration_name = "frontend_config"
    frontend_port_name             = "frontend_port"
    protocol                       = "Http"
  }

  probe {
    name                = "probe"
    protocol            = "http"
    path                = "/"
    host                = azurerm_app_service.webapp01.default_site_hostname
    interval            = "30"
    timeout             = "30"
    unhealthy_threshold = "3"
  }

  backend_http_settings {
    name                  = "backend_settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
    probe_name            = "probe"

    # Use this to avoid error 404 when reaching WebApp01
    pick_host_name_from_backend_address = true
  }

  request_routing_rule {
    name                       = "http_routing"
    rule_type                  = "Basic"
    http_listener_name         = "http"
    backend_address_pool_name  = "WebApp01"
    backend_http_settings_name = "backend_settings"
  }
}