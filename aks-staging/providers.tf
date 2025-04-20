terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.26.0"
    }
     helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate835"
      container_name       = "tfstate"
      key                  = "staging/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}