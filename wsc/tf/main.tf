terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.115.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "service_bus_rg" {
  name     = "service-bus-rg"
  location = "East US"
}

# Service Bus Namespace
resource "azurerm_servicebus_namespace" "namespace" {
  name                = "service-bus-ACME"
  location            = azurerm_resource_group.service_bus_rg.location
  resource_group_name = azurerm_resource_group.service_bus_rg.name
  sku                 = "Standard"
}

# Service Bus Topic
resource "azurerm_servicebus_topic" "topic" {
  name         = "job-topic"
  namespace_id = azurerm_servicebus_namespace.namespace.id
}

# Service Bus Subscription
resource "azurerm_servicebus_subscription" "subscription" {
  name     = "job-subscription"
  topic_id = azurerm_servicebus_topic.topic.id
  max_delivery_count = 10
  lock_duration      = "PT1M"
}

#######################################################


# Resource Group
resource "azurerm_resource_group" "aksrg" {
  name     = "aks-resource-group"
  location = "East US"
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "wsctaskforshahar"
  resource_group_name = azurerm_resource_group.aksrg.name
  location            = azurerm_resource_group.aksrg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Azure Kubernetes Service Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "wscaks"
  location            = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_resource_group.aksrg.name
  dns_prefix          = "wscaks"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_B2pls_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

# Assign ACR Pull Role to AKS
resource "azurerm_role_assignment" "role_assignment" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
}


