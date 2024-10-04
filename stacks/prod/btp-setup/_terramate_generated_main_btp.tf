// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "random_uuid" "uuid" {
}
locals {
  random_uuid          = random_uuid.uuid.result
  subaccount_cf_org    = length(var.cf_org_name) > 0 ? var.cf_org_name : substr(replace("${local.subaccount_subdomain}", "-", ""), 0, 32)
  subaccount_name      = var.subaccount_name != "" ? var.subaccount_name : "${var.subaccount_subdomain_prefix}-${local.random_uuid}"
  subaccount_subdomain = lower("${var.subaccount_subdomain_prefix}-${local.random_uuid}")
}
resource "btp_subaccount" "integration_suite" {
  name      = local.subaccount_name
  region    = lower(var.region)
  subdomain = local.subaccount_subdomain
}
module "sap-btp-entitlements" {
  entitlements = var.entitlements
  source       = "aydin-ozcan/sap-btp-entitlements/btp"
  subaccount   = btp_subaccount.integration_suite.id
  version      = "1.0.1"
}
resource "btp_subaccount_subscription" "integrationsuite" {
  app_name = "integrationsuite"
  depends_on = [
    module.sap-btp-entitlements,
  ]
  plan_name     = "standard_edition"
  subaccount_id = btp_subaccount.integration_suite.id
}
resource "btp_subaccount_role_collection_assignment" "Integration_Provisioner" {
  depends_on = [
    btp_subaccount_subscription.integrationsuite,
  ]
  for_each             = toset(var.integration_provisioners)
  role_collection_name = "Integration_Provisioner"
  subaccount_id        = btp_subaccount.integration_suite.id
  user_name            = each.value
}
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.integration_suite.id
}
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  environment_type = "cloudfoundry"
  landscape_label  = terraform_data.cf_landscape_label.output
  name             = var.instance_name
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
  plan_name     = "standard"
  service_name  = "cloudfoundry"
  subaccount_id = btp_subaccount.integration_suite.id
}
resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
  for_each             = toset(var.subaccount_admins)
  role_collection_name = "Subaccount Administrator"
  subaccount_id        = btp_subaccount.integration_suite.id
  user_name            = each.value
}
resource "local_file" "output_vars_step1" {
  content = <<-EOT
cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
cf_org_id            = "${btp_subaccount_environment_instance.cloudfoundry.platform_id}"
cf_space_name        = "${var.cf_space_name}"
cf_org_admins        = ${jsonencode(var.cf_org_admins)}
cf_org_users         = ${jsonencode(var.cf_org_users)}
cf_space_developers  = ${jsonencode(var.cf_space_developers)}
cf_space_managers    = ${jsonencode(var.cf_space_managers)}
s4_connection_pw     = "${var.s4_connection_pw}"
EOT

  count    = var.create_tfvars_file_for_cf ? 1 : 0
  filename = "../cf-setup/terraform.tfvars"
}
