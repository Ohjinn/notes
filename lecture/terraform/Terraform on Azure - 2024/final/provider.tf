terraform {
  required_providers {
    azapi = {
        source  = "azure/azapi"        
        version = "~> 2.0"
    }
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.0"
    }
    random = {
        source  = "hashicorp/random"
        version = "~>3.0"
    }
    time = {
        source = "hashicorp/time"
        version = "0.9.1"
    }
  }
}

provider "azurerm" {

features {}
subscription_id="3529bbd8-1033-460a-9cb4-d925a697c7fb"
}
