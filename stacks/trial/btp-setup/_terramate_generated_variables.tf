// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "globalaccount" {
  description = "The globalaccount subdomain where the sub account shall be created."
  type        = string
}
variable "btp_username" {
  description = "The username for the SAP BTP account."
  type        = string
}
variable "create_tfvars_file_for_cf" {
  default     = true
  description = "Create a tfvars file for the Cloud Foundry setup."
  type        = bool
}
variable "subaccount_subdomain_prefix" {
  default     = "microsoft"
  description = "The prefix for the SAP BTP subaccount subdomain."
  type        = string
}
variable "subaccount_name" {
  default     = ""
  description = "The name for the SAP BTP subaccount."
  type        = string
}
variable "region" {
  default     = "eu20"
  description = "The region where the sub account shall be created in."
  type        = string
}
variable "subaccount_admins" {
  default = [
  ]
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  type        = list(string)
}
variable "integration_provisioners" {
  default = [
  ]
  description = "Defines the colleagues who are added to each subaccount as Integration Suite Provisioner."
  type        = list(string)
}
variable "instance_name" {
  default     = "sap-is-instance"
  description = "The name of the cloudfoundry environment instance."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\.]{1,32}$", var.instance_name))
    error_message = "Please provide a valid instance name."
  }
}
variable "entitlements" {
  default = {
    destination = [
      "lite",
    ]
    integrationsuite-trial = [
      "trial=1",
    ]
    it-rt = [
      "integration-flow",
    ]
  }
  description = "The entitlements for the subaccount."
  type        = map(list(string))
}
variable "cf_landscape_label" {
  default     = ""
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  type        = string
}
variable "cf_org_name" {
  default     = ""
  description = "The name of the cloudfoundry organization."
  type        = string
  validation {
    condition     = can(regex("^.{0,255}$", var.cf_org_name))
    error_message = "The cloudfoundry org name must not exceed 255 characters"
  }
}
variable "cf_org_id" {
  default     = ""
  description = "The ID of the Cloud Foundry org."
  type        = string
}
variable "cf_space_name" {
  default     = "dev"
  description = "The name of the Cloud Foundry space."
  type        = string
}
variable "cf_org_admins" {
  description = "CF Org Admins"
  type        = list(string)
}
variable "cf_org_users" {
  description = "CF Org Users"
  type        = list(string)
}
variable "cf_space_developers" {
  description = "CF Space developers"
  type        = list(string)
}
variable "cf_space_managers" {
  description = "CF Space managers"
  type        = list(string)
}
variable "s4_connection_pw" {
  description = "Password for the RFC destination to the S/4HANA system"
  sensitive   = true
  type        = string
}
