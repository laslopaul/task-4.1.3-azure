output "public_ip" {
  description = "Public IP of App Gateway"
  value       = azurerm_public_ip.publicip_appgw.ip_address
}

output "webapp_hostname" {
  description = "WebApp01 hostname"
  value       = azurerm_app_service.webapp01.default_site_hostname
}
