variable "sub_id" {
  description = "The subscription ID for the Azure account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location/region where resources will be deployed"
  type        = string
}

variable "cosmosdb_location" {
  description = "The location/region for the CosmosDB account"
  type        = string
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}

# Add the random provider
provider "random" {}

# Generate a random name for reource prefix 
# Generate a random name
resource "random_pet" "random_name" {
  length    = 2
  separator = "-"
}

#create resource group
resource "azurerm_resource_group" "main" {
  name     = "${random_pet.random_name.id}-${var.resource_group_name}"
  location = var.location
}

#create app service plan
resource "azurerm_service_plan" "linux_plan" {
  name                = "${random_pet.random_name.id}-linux-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "P0v3"
  os_type             = "Linux"
}

#create app service
resource "azurerm_app_service" "app_service" {
  name                = "${random_pet.random_name.id}-my-simplechat-app"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_service_plan.linux_plan.id

  site_config {
    linux_fx_version = "DOCKER|mcr.microsoft.com/azure-app-service/samples:node"
  }
}

#create cognitive account for openai
resource "azurerm_cognitive_account" "openai" {
  name                = "${random_pet.random_name.id}-openai-account"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "OpenAI"
  sku_name            = "S0"
}

#create ai search service
resource "azurerm_search_service" "ai_search" {
  name                = "${random_pet.random_name.id}-ai-search"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "standard"
  replica_count       = 1
  partition_count     = 1
}

#create cosmosdb account
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${random_pet.random_name.id}-cosmosdb-account"
  location            = var.cosmosdb_location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
    zone_redundant    = false
  }

  capabilities {
    name = "EnableNoSQLVectorSearch"
  }

  # Removed invalid attribute enable_multiple_write_locations
  consistency_policy {
    consistency_level = "Session"
  }
}

#create cognitive account for document intelligence
resource "azurerm_cognitive_account" "document_intelligence" {
  name                = "${random_pet.random_name.id}-document-intelligence"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "FormRecognizer"
  sku_name            = "S0"
}

#create cognitive account for content safety
resource "azurerm_cognitive_account" "content_safety" {
  name                = "${random_pet.random_name.id}-content-safety"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "ContentSafety"
  sku_name            = "S0"
}

#create cognitive account for bing search  FAILING - Bing Search is not available in cog svc any longer?
# resource "azurerm_cognitive_account" "bing_search" {
#   name                = "${random_pet.random_name.id}-bing-search"
#   location            = "Global"
#   resource_group_name = azurerm_resource_group.main.name
#   kind                = "Bing.Search.v7"
#   sku_name            = "S1"
# }

#call powershell script to create .env file
resource "null_resource" "run_powershell" {
  provisioner "local-exec" {
    command = "powershell -File ./scripts/deploy.ps1"
  }
}

#output the app service url
output "app_service_url" {
  value = "https://${azurerm_app_service.app_service.default_site_hostname}"
  description = "The URL of the deployed App Service"
}