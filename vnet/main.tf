provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.vnet_location
}

resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  location            = var.vnet_location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "example" {
  for_each            = var.use_for_each ? toset(var.subnet_names) : []
  name                = each.key
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name= azurerm_virtual_network.example.name
  address_prefixes    = var.use_for_each ? [var.subnet_prefixes[index(var.subnet_names, each.key)]] : []
  service_endpoints   = var.subnet_service_endpoints[each.key]
}

resource "azurerm_network_security_group" "example" {
  for_each            = var.nsg_ids
  name                = "nsg-${each.key}"
  location            = var.vnet_location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  for_each = var.nsg_ids
  subnet_id = azurerm_subnet.example[each.key].id
  network_security_group_id = azurerm_network_security_group.example[each.key].id
}

resource "azurerm_route_table" "example" {
  for_each = var.route_tables_ids
  name                = "rt-${each.key}"
  location            = var.vnet_location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet_route_table_association" "example" {
  for_each = var.route_tables_ids
  subnet_id = azurerm_subnet.example[each.key].id
  route_table_id = azurerm_route_table.example[each.key].id
}