generate_hcl "_terramate_generated_provider.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/cf*",
      "stacks/trial/cf*",
    ]
  }
  content {
    terraform {

      required_providers {
        btp = {
          source  = "SAP/btp"
          version = global.terraform.providers.btp.version
        }
        cloudfoundry = {
          source  = "cloudfoundry/cloudfoundry"
          version = global.terraform.providers.cloudfoundry.version
        }
      }
    }
    provider "btp" {
      globalaccount = var.globalaccount
      username      = var.btp_username
    }

    provider "cloudfoundry" {
      api_url = var.cf_api_url
      user    = var.btp_username
    }
  }
}
