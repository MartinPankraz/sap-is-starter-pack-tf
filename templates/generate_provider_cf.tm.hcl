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
        cloudfoundry = {
          source  = "cloudfoundry/cloudfoundry"
          version = global.terraform.providers.cloudfoundry.version
        }
      }
    }
    provider "cloudfoundry" {
      api_url = var.cf_api_url
    }
  }
}
