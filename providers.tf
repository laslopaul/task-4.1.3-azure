terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
    
    # Add pkcs12 provider for generation of self-signed SSL cert
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "=0.0.7"
    }
  }
}

provider "azurerm" {
  features {}
}