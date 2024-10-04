// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

variable "cf_api_url" {
  description = "The Cloud Foundry API URL"
  type        = string
}
variable "cf_org_id" {
  description = "The ID of the Cloud Foundry org."
  type        = string
}
variable "cf_space_name" {
  default     = "dev"
  description = "The name of the Cloud Foundry space."
  type        = string
}
variable "origin_key" {
  default     = "sap.ids"
  description = "The origin key for the Cloud Foundry roles."
  type        = string
}
variable "cf_org_admins" {
  default = [
    "",
  ]
  description = "CF Org Admins"
  type        = list(string)
}
variable "cf_org_users" {
  default = [
    "",
  ]
  description = "CF Org Users"
  type        = list(string)
}
variable "cf_space_developers" {
  default = [
    "",
  ]
  description = "CF Space developers"
  type        = list(string)
}
variable "cf_space_managers" {
  default = [
    "",
  ]
  description = "CF Space managers"
  type        = list(string)
}
variable "s4_connection_pw" {
  description = "Password for the RFC destination to the S/4HANA system"
  sensitive   = true
  type        = string
}
