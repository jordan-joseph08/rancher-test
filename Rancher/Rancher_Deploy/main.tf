terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.62.1"
    }
  }

  backend "azurerm" {
    resource_group_name = "test-rg"
    storage_account_name = "teststorageaccount9408"
    container_name = "statefiles"
    key = "rancher-statefile"
  }
}
provider "azurerm" {
 features {}
}