// Configure default Terraform version and default providers
globals "terraform" "providers" "btp" {
  version = "~> 1.7.0"
}

globals "terraform" "providers" "cloudfoundry" {
  version = "1.0.0-rc1"
}

globals "terraform" "modules" "btp_entitlement" {
  source  = "aydin-ozcan/sap-btp-entitlements/btp"
  version = "1.0.1"
}


globals "terraform" "variables" "entitlements" {
  destinationsrvc                = "destination"
  destinationsrvcplan            = "lite"
  destinationsrvctrial           = "destination"
  destinationsrvcplantrial       = "lite"
  integrationssuitesrvc          = "integrationsuite"
  integrationssuitesrvcplan      = "standard_edition=1"
  integrationssuitesrvctrial     = "integrationsuite-trial"
  integrationssuitesrvcplantrial = "trial=1"
  itrtsrvc                       = "it-rt"
  itrtsrvcplan                   = "integration-flow"
  itrtsrvctrial                  = "it-rt"
  itrtsrvcplantrial              = "integration-flow"
}
