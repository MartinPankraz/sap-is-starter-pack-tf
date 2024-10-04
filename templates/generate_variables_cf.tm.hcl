generate_hcl "_terramate_generated_variables.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/cf*",
      "stacks/trial/cf*",
    ]
  }

  content {
    # ------------------------------------------------------------------------------------------------------
    # BTP-specific variables
    # ------------------------------------------------------------------------------------------------------
    variable "globalaccount" {
      type        = string
      description = "The globalaccount subdomain where the sub account shall be created."
    }

    variable "btp_username" {
      type        = string
      description = "The username for the SAP BTP account."
    }

    variable "subaccount_id" {
      type        = string
      description = "The ID of the subaccount."
      default     = ""
    }

    variable "pi_administrator" {
      type        = list(string)
      description = "The email address of the PI administrator."
      default     = []
    }

    variable "pi_business_expert" {
      type        = list(string)
      description = "The email address of the PI business expert."
      default     = []
    }

    variable "pi_integration_developer" {
      type        = list(string)
      description = "The email address of the PI integration developer."
      default     = []
    }

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

  }
}
