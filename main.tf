provider "azurerm" {
  features {}
  subscription_id = "4378f194-c619-4dc3-a861-13ad4c854286"
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "rg" {
  name     = "Harshita-rg-isolation"
  location = "Central US"
}

resource "azurerm_storage_account" "storage" {
  name                     = "storingharshitaaacct123"     # must be globally unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "plan" {
  name                = "service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1"  # Y1 = Dynamic (Consumption plan)
}

resource "azurerm_linux_function_app" "function" {
  name                       = "harshita-function-app-java123-hd"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.plan.id

  site_config {
    
  }
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"   = "java"
    "WEBSITE_RUN_FROM_PACKAGE"   = "1"
    "JAVA_VERSION"           = "17"  
  }
}