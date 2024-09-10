terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.10.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "vinted-rg"
    storage_account_name = "vintedstoragetfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 1.9.5"
}

provider "okta" {
  org_name  = data.azurerm_key_vault_secret.org_name_secret.value
  base_url  = data.azurerm_key_vault_secret.base_url_secret.value
  api_token = data.azurerm_key_vault_secret.api_token_secret.value
}

provider "azurerm" {
  subscription_id = var.azurerm_subscription_id
  features {}
}

# Attempt to store secrets in KeyVault

data "azurerm_key_vault" "vinted_keyvault" {
  name                = "vinted" 
  resource_group_name = var.vinted_rg_name
}

data "azurerm_key_vault_secret" "api_token_secret" {
  name         = "apiToken"
  key_vault_id = data.azurerm_key_vault.vinted_keyvault.id    
}

data "azurerm_key_vault_secret" "base_url_secret" {
  name         = "baseUrl"
  key_vault_id = data.azurerm_key_vault.vinted_keyvault.id    
}

data "azurerm_key_vault_secret" "org_name_secret" {
  name         = "orgName"
  key_vault_id = data.azurerm_key_vault.vinted_keyvault.id    
}
