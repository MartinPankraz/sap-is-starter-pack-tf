generate_hcl "_terramate_generated_variables.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/cf*",
      "stacks/trial/cf*",
    ]
  }

  content {
    # ------------------------------------------------------------------------------------------------------
    # CF-specific variables
    # ------------------------------------------------------------------------------------------------------
    variable "cf_api_url" {
      description = "The Cloud Foundry API URL"
      type        = string
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

    variable "origin_key" {
      type        = string
      description = "The origin key for the Cloud Foundry roles."
      default     = "sap.ids"
    }

    variable "cf_org_admins" {
      type        = list(string)
      description = "CF Org Admins"
      default     = [""]
    }

    variable "cf_org_users" {
      type        = list(string)
      description = "CF Org Users"
      default     = [""]
    }

    variable "cf_space_developers" {
      type        = list(string)
      description = "CF Space developers"
      default     = [""]
    }

    variable "cf_space_managers" {
      type        = list(string)
      description = "CF Space managers"
      default     = [""]
    }


    # ------------------------------------------------------------------------------------------------------
    # Scenario-specific variables
    # ------------------------------------------------------------------------------------------------------
    variable "s4_connection_pw" {
      type        = string
      description = "Password for the RFC destination to the S/4HANA system"
      sensitive   = true
    }
  }
}
