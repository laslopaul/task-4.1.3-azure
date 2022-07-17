# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "RG_TASK_413"
  location = "eastus"
}

# Create public IP for app gateway
resource "azurerm_public_ip" "publicip_appgw" {
  name                = "PublicIP_AppGw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet0" {
  name                = "VNET01"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet for app gateway
resource "azurerm_subnet" "appgw_subnet" {
  name                 = "AppGwSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet0.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Web"]
}
