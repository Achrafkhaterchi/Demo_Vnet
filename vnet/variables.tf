variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_location" {
  description = "The location of the virtual network"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "tags" {
  description = "The tags to associate with the resources"
  type        = map(string)
}

variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "List of subnet address prefixes"
  type        = list(string)
}

variable "subnet_service_endpoints" {
  description = "Map of subnet service endpoints"
  type        = map(list(string))
}

variable "nsg_ids" {
  description = "Map of NSG IDs"
  type        = map(string)
}

variable "route_tables_ids" {
  description = "Map of route table IDs"
  type        = map(string)
}

variable "use_for_each" {
  description = "Whether to use for_each for subnet configuration"
  type        = bool
}
