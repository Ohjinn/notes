terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"  # 최신 버전 사용을 권장합니다.
    }
  }
}
provider "azurerm" {

features {}
subscription_id = "3529bbd8-1033-460a-9cb4-d925a697c7fb"
}
