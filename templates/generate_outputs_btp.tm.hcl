generate_hcl "_terramate_generated_output_btp.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/btp*",
      "stacks/trial/btp*",
    ]
  }

  content {
    output "globalaccount" {
      value       = var.globalaccount
      description = "The globalaccount subdomain where the sub account shall be created."
    }

    output "btp_username" {
      value       = var.btp_username
      description = "The username for the SAP BTP account."
    }

    output "subaccount_id" {
      value       = btp_subaccount.integration_suite.id
      description = "The ID of the subaccount."
    }

    output "pi_administrator" {
      value       = var.pi_administrator
      description = "The email address of the PI administrator."
    }

    output "pi_business_expert" {
      value       = var.pi_business_expert
      description = "The email address of the PI business expert."
    }

    output "pi_integration_developer" {
      value       = var.pi_integration_developer
      description = "The email address of the PI integration developer."
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
  }
}
