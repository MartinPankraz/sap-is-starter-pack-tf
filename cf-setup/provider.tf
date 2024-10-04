# https://registry.terraform.io/providers/SAP/btp/latest/docs
terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.0.0-rc1"
    }
  }
}

# Configure the BTP Provider
provider "cloudfoundry" {
  api_url = var.cf_api_url
}
