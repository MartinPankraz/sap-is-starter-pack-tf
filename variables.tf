variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_id" {
  type        = string
  description = "The ID of the SAP BTP subaccount."
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "eu20"
}

variable "instance_name" {
  type        = string
  description = "The name of the cloudfoundry environment instance."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\.]{1,32}$", var.instance_name))
    error_message = "Please provide a valid instance name."
  }
}

variable "cloudfoundry_org_name" {
  type        = string
  description = "The name of the cloudfoundry organization."

  validation {
    condition     = can(regex("^.{1,255}$", var.cloudfoundry_org_name))
    error_message = "The cloudfoundry org name must not be emtpy and not exceed 255 characters"
  }
}

variable "cf_org_id" {
  type        = string
  description = "The ID of the Cloud Foundry org."
}

variable "s4_connection_pw" {
  type        = string
  description = "Password for the RFC destination to the S/4HANA system"
  sensitive   = true
}