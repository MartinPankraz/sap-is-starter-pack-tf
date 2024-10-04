// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

output "subaccount_id" {
  description = "The ID of the subaccount."
  value       = btp_subaccount.integration_suite.id
}
output "cf_org_id" {
  description = "The ID of the Cloud Foundry org connected to the subaccount."
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id
}
output "cf_api_url" {
  description = "API endpoint of the Cloud Foundry environment."
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
}
output "cf_space_name" {
  description = "The name of the Cloud Foundry space."
  value       = var.cf_space_name
}
output "cf_org_admins" {
  description = "List of Cloud Foundry org admins."
  value       = var.cf_org_admins
}
output "cf_org_users" {
  description = "List of Cloud Foundry org users."
  value       = var.cf_org_users
}
output "cf_space_managers" {
  description = "List of managers for the Cloud Foundry space."
  value       = var.cf_space_managers
}
output "cf_space_developers" {
  description = "List of developers for the Cloud Foundry space."
  value       = var.cf_space_developers
}
