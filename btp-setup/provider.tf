# https://registry.terraform.io/providers/SAP/btp/latest/docs
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~>1.7.0"
    }
  }
}

# Configure the BTP Provider
provider "btp" {
  globalaccount = var.globalaccount
}
