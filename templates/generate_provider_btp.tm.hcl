generate_hcl "_terramate_generated_provider.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/btp*",
      "stacks/trial/btp*",
    ]
  }
  content {
    terraform {

      required_providers {
        btp = {
          source  = "SAP/btp"
          version = global.terraform.providers.btp.version
        }
      }
    }
    provider "btp" {
      globalaccount = var.globalaccount
      username      = var.btp_username
    }
  }
}
