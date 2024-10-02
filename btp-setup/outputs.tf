output "subaccount_id" {
  value       = btp_subaccount.integration_suite.id
  description = "The ID of the subaccount."
}

output "cf_org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id
  description = "The ID of the Cloud Foundry org connected to the subaccount."
}

output "cf_api_url" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}

output "cf_space_name" {
  value       = var.cf_space_name
  description = "The name of the Cloud Foundry space."
}

output "cf_org_admins" {
  value       = var.cf_org_admins
  description = "List of Cloud Foundry org admins."
}

output "cf_org_users" {
  value       = var.cf_org_users
  description = "List of Cloud Foundry org users."
}

output "cf_space_managers" {
  value       = var.cf_space_managers
  description = "List of managers for the Cloud Foundry space."
}

output "cf_space_developers" {
  value       = var.cf_space_developers
  description = "List of developers for the Cloud Foundry space."
}
