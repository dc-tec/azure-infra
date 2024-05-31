variable "location" {
  description = "The Azure Region in which the resources should exist."
  type        = string
  default     = "westeu"

  validation {
    condition     = can(regex("^(westeu|northeu)$", var.location))
    error_message = "Location must be one of westeu or northeu"
  }
}

variable "location_full" {
  description = "The full Azure Region in which the resources should exist."
  type        = string
  default     = "westeurope"

  validation {
    condition     = can(regex("^(westeurope|northeurope)$", var.location_full))
    error_message = "Location must be one of westeurope or northeurope"
  }
}
