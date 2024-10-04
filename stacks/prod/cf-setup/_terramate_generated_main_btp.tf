// TERRAMATE: GENERATED AUTOMATICALLY DO NOT EDIT

resource "cloudfoundry_space" "cf_space" {
  name = var.cf_space_name
  org  = var.cf_org_id
}
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset(var.cf_org_users)
  org      = var.cf_org_id
  origin   = var.origin_key
  type     = "organization_user"
  username = each.value
}
resource "cloudfoundry_org_role" "organization_manager" {
  for_each = toset(var.cf_org_admins)
  org      = var.cf_org_id
  origin   = var.origin_key
  type     = "organization_manager"
  username = each.value
}
resource "cloudfoundry_space_role" "space_developer" {
  depends_on = [
    cloudfoundry_org_role.organization_user,
    cloudfoundry_org_role.organization_manager,
  ]
  for_each = toset(var.cf_space_developers)
  origin   = var.origin_key
  space    = cloudfoundry_space.cf_space.id
  type     = "space_developer"
  username = each.value
}
resource "cloudfoundry_space_role" "space_manager" {
  depends_on = [
    cloudfoundry_org_role.organization_user,
    cloudfoundry_org_role.organization_manager,
  ]
  for_each = toset(var.cf_space_managers)
  origin   = var.origin_key
  space    = cloudfoundry_space.cf_space.id
  type     = "space_manager"
  username = each.value
}
data "cloudfoundry_service" "it_rt_service_plans" {
  name = "it-rt"
}
resource "cloudfoundry_service_instance" "it_rt__integration_flow" {
  depends_on = [
    cloudfoundry_space_role.space_manager,
    cloudfoundry_space_role.space_developer,
  ]
  name         = "cpi-rt"
  service_plan = data.cloudfoundry_service.it_rt_service_plans.service_plans["integration-flow"]
  space        = cloudfoundry_space.cf_space.id
  timeouts = {
    create = "1h"
    delete = "1h"
    update = "1h"
  }
  type = "managed"
}
resource "cloudfoundry_service_credential_binding" "cpi_rt_key" {
  name             = "cpi-rt-key"
  service_instance = cloudfoundry_service_instance.it_rt__integration_flow.id
  type             = "key"
}
data "cloudfoundry_service" "destination_service_plans" {
  name = "destination"
}
resource "cloudfoundry_service_instance" "destination__lite" {
  depends_on = [
    cloudfoundry_space_role.space_manager,
    cloudfoundry_space_role.space_developer,
  ]
  name = "cpi-destination"
  parameters = jsonencode({
    "HTML5Runtime_enabled" = "true"
    "init_data" = {
      "instance" = {
        "existing_destinations_policy" = "update"
        "destinations" = [
          {
            "AuthorizationType" = "CONFIGURED_USER"
            "Name"              = "SID_RFC"
            "Description"       = "SAP S/4HANA Connection via RFC"
            "ProxyType"         = "OnPremise"
            "Type"              = "RFC"
            "User"              = "BPINST"
            "Password"          = "${var.s4_connection_pw}"
            "jco.client.ashost" = "your-virtual-host-name"
            "jco.client.client" = "100"
            "jco.client.lang"   = "EN"
            "jco.client.sysnr"  = "00"
          },
        ]
      }
    }
  })
  service_plan = data.cloudfoundry_service.destination_service_plans.service_plans["lite"]
  space        = cloudfoundry_space.cf_space.id
  type         = "managed"
}
