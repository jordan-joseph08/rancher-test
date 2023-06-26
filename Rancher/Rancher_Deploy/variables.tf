variable "vm_count" {
  description = "Number of virtual machines to create"
  default     = 3
}

variable "resource_group_name" {
  description = "Name of the resource group"
  default     = "private-rg"
}

variable "location" {
  description = "Azure region where the resources will be created"
  default     = "eastus"
}

variable "vm_size" {
  description = "Azure virtual machine size"
  default     = "Standard_DS2_v2"
}

variable "username" {
  description = "Virtual machine administrator username"
  default     = "adminuser"
}

variable "password" {
  description = "Virtual machine administrator password"
  type = string
  sensitive = true
}
