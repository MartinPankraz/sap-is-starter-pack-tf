# ------------------------------------------------------------------------------------------------------
# BTP-specific variables
# ------------------------------------------------------------------------------------------------------
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "create_tfvars_file_for_cf" {
  type        = bool
  description = "Create a tfvars file for the Cloud Foundry setup."
  default     = true
}

variable "subaccount_subdomain_prefix" {
  type        = string
  description = "The prefix for the SAP BTP subaccount subdomain."
  default     = "microsoft"
}

variable "subaccount_name" {
  type        = string
  description = "The name for the SAP BTP subaccount."
  default     = ""
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "eu20"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = [""]
}

variable "instance_name" {
  type        = string
  description = "The name of the cloudfoundry environment instance."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\.]{1,32}$", var.instance_name))
    error_message = "Please provide a valid instance name."
  }
}

variable "entitlements" {
  type        = map(list(string))
  description = "The entitlements for the subaccount."
  default = {
    "destination"       = ["lite"],
    "integration_suite" = ["standard_edition"],
    "it_rt"             = ["integration_flow=1"]
  }
}

# ------------------------------------------------------------------------------------------------------
# CF-specific variables
# ------------------------------------------------------------------------------------------------------
variable "cf_landscape_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}


variable "cf_org_name" {
  type        = string
  description = "The name of the cloudfoundry organization."

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The cloudfoundry org name must not be emtpy and not exceed 255 characters"
  }
}

variable "cf_org_id" {
  type        = string
  description = "The ID of the Cloud Foundry org."
}

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
}

# ------------------------------------------------------------------------------------------------------
# Scenario-specific variables
# ------------------------------------------------------------------------------------------------------
variable "s4_connection_pw" {
  type        = string
  description = "Password for the RFC destination to the S/4HANA system"
  sensitive   = true
}
