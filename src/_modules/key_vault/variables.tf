variable "environment" {
  description = "The environment in which the resources should exist."
  type        = string

  validation {
    condition     = can(regex("^(prd|dev|tst)$", var.environment))
    error_message = "Environment must be one of prd, dev or tst"
  }
}

variable "location" {
  description = "The Azure Region in which the resources should exist."
  type        = string
  default     = "westeu"

  validation {
    condition     = can(regex("^(westeu|northeu)$", var.location))
    error_message = "Location must be one of westeu or northeu"
  }
}

variable "resource_group" {
  description = "The name of the Resource Group in which the resources should exist."
  type        = string
}


variable "name" {
  description = "The name of the Key Vault."
  type        = string
}

variable "access_policies" {
  description = "A list of maps defining the access policies for the Key Vault."
  type = list(object({
    applications = list(string)
    groups       = list(string)
    role_name    = string
  }))
}

variable "allowed_ips" {
  description = "A list of IP addresses that are allowed to access the Key Vault."
  type        = list(string)
}

variable "virtual_network_subnets" {
  description = "A list of Subnet IDs that are allowed to access the Key Vault."
  type        = list(string)
}
