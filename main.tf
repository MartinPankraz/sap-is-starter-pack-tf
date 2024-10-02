# ------------------------------------------------------------------------------------------------------
# Define local variables
# ------------------------------------------------------------------------------------------------------
locals {
  name_prefix      = "microsoft"
  subaccount_name  = "${local.name_prefix}-${local.name_suffix}"
}

# ------------------------------------------------------------------------------------------------------
# Create subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "this" {
  name      = local.subaccount_name
  subdomain = replace(lower(local.subaccount_name), "-", "")
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Set all entitlements in the subaccount
# ------------------------------------------------------------------------------------------------------
# Set entitlement for destination service
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.this.id
  service_name  = "destination"
  plan_name     = "lite"
}

resource "btp_subaccount_entitlement" "integration_suite" {
  subaccount_id = var.subaccount_id
  service_name  = "integration_suite"
  plan_name     = "standard_edition"
}

resource "btp_subaccount_entitlement" "process_integration_runtime" {
  subaccount_id = btp_subaccount.this.id
  service_name  = "it_rt"
  plan_name     = "integration_flow"
  amount        = 1
}

# ------------------------------------------------------------------------------------------------------
# Create Cloudfoundry environment instance
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = var.subaccount_id
  name             = var.instance_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = var.cloudfoundry_org_name
  })
}

# ------------------------------------------------------------------------------------------------------
# Create Cloud Foundry space dev
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = "dev"
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Create a CF service instance
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_instance" "service" {
  name         = var.service_instance_name
  space        = var.cf_space_id
  service_plan = data.cloudfoundry_service.service.service_plans["${var.plan_name}"]
  json_params  = var.parameters
}

# ------------------------------------------------------------------------------------------------------
# Create a Process Integration Runtime instance
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_instance" "service" {
  name         = "cpi-rt"
  space        = var.cf_space_id
  service_plan = "integration_flow"
}

# ------------------------------------------------------------------------------------------------------
# Create service key for Process Integration Runtime
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_key" "privatelink" {
  name             = "privatelink_cf_service_key"
  service_instance = module.create_cf_service_instance_privatelink.id
}

# ------------------------------------------------------------------------------------------------------
# Create destination service + RFC destination to S/4HANA
# ------------------------------------------------------------------------------------------------------
module "create_cf_service_instance_destination" {
  source                = "modules/cloudfoundry/cf-service-instance"
  cf_space_id           = data.cloudfoundry_space.dev.id
  service_name          = "destination"
  service_instance_name = "audit-log-destination"
  plan_name             = "lite"
  parameters = jsonencode({
    "HTML5Runtime_enabled" : "true",
    "init_data" : {
      "instance" : {
        "existing_destinations_policy" : "update",
        "destinations" : [
          {
            "AuthorizationType"        = "CONFIGURED_USER",
            "Name"                     = "SID_RFC",
            "Description"              = "SAP S/4HANA Connection via RFC",
            "ProxyType"                = "OnPremise",
            "Type"                     = "RFC",
            "URL"                      = "https://your-server:50000",
            "User"                     = "BPINST"
            "Password"                 = "${var.s4_connection_pw}"
            "jco.client.ashost"        = "your-virtual-host-name"
            "jco.client.client"        = "100"
            "jco.client.lang"          = "EN"
            "jco.client.sysnr"         = "00"
          }
        ]
      }
    }
  })
}

# ------------------------------------------------------------------------------------------------------
# Assign the subaccount roles to the users
# ------------------------------------------------------------------------------------------------------
# Subaccount Administrator
#resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
#  subaccount_id        = btp_subaccount.this.id
#  role_collection_name = "Subaccount Administrator"
#  for_each             = toset(concat(var.admins, ["xp160-${var.user_number}@education.cloud.sap"]))
#  user_name            = each.value
#  depends_on           = [btp_subaccount.this]
#}
