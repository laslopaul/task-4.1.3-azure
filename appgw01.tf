# Create Application Gateway
resource "azurerm_application_gateway" "appgw01" {
  name                = "AppGw01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_V2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "AppGwSubnet"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  ssl_certificate {
    name     = "self_signed_cert"
    data     = pkcs12_from_pem.self_signed_cert.result
    password = random_password.self_signed_cert.result
  }

  frontend_port {
    name = "frontend_port"
    port = 443
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
    protocol                       = "Https"
    ssl_certificate_name           = "self_signed_cert"
  }

  backend_http_settings {
    name                  = "backend_settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 1

    # Use this to avoid error 404 when reaching WebApp01
    pick_host_name_from_backend_address = true
  }

  request_routing_rule {
    name                       = "rule01"
    rule_type                  = "Basic"
    http_listener_name         = "listener"
    backend_address_pool_name  = "WebApp01"
    backend_http_settings_name = "backend_settings"
  }
}