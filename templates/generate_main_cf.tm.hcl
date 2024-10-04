generate_hcl "_terramate_generated_main_btp.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/cf*",
      "stacks/trial/cf*",
    ]
  }

  lets {
    destinationsrvcname     = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "destination", "destination")
    destinationsrvcplanname = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "lite", "lite")
    itrtsrvcname            = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "it-rt", "it-rt")
    itrtsrvcplanname        = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "integration-flow", "integration-flow")
  }

  content {
    # ------------------------------------------------------------------------------------------------------
    # Create Cloud Foundry space dev
    # ------------------------------------------------------------------------------------------------------
    resource "cloudfoundry_space" "cf_space" {
      name = var.cf_space_name
      org  = var.cf_org_id
    }

    # ------------------------------------------------------------------------------------------------------
    # Assign a CLoud Foundry org and space roles
    # ------------------------------------------------------------------------------------------------------
    resource "cloudfoundry_org_role" "organization_user" {
      for_each = toset(var.cf_org_users)
      username = each.value
      type     = "organization_user"
      org      = var.cf_org_id
      origin   = var.origin_key
    }

    resource "cloudfoundry_org_role" "organization_manager" {
      for_each = toset(var.cf_org_admins)
      username = each.value
      type     = "organization_manager"
      org      = var.cf_org_id
      origin   = var.origin_key
    }

    resource "cloudfoundry_space_role" "space_developer" {
      for_each   = toset(var.cf_space_developers)
      username   = each.value
      type       = "space_developer"
      space      = cloudfoundry_space.cf_space.id
      origin     = var.origin_key
      depends_on = [cloudfoundry_org_role.organization_user, cloudfoundry_org_role.organization_manager]
    }

    resource "cloudfoundry_space_role" "space_manager" {
      for_each   = toset(var.cf_space_managers)
      username   = each.value
      type       = "space_manager"
      space      = cloudfoundry_space.cf_space.id
      origin     = var.origin_key
      depends_on = [cloudfoundry_org_role.organization_user, cloudfoundry_org_role.organization_manager]
    }

    # ------------------------------------------------------------------------------------------------------
    # Create a CLoud Foundry service instance for Process Integration Runtime
    # ------------------------------------------------------------------------------------------------------
    data "cloudfoundry_service" "it_rt_service_plans" {
      name = "${let.itrtsrvcname}"
    }

    resource "cloudfoundry_service_instance" "it_rt__integration_flow" {
      depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer]
      name         = "cpi-rt"
      space        = cloudfoundry_space.cf_space.id
      service_plan = data.cloudfoundry_service.it_rt_service_plans.service_plans["${let.itrtsrvcplanname}"]
      type         = "managed"
      timeouts = {
        create = "1h"
        delete = "1h"
        update = "1h"
      }
    }

    # ------------------------------------------------------------------------------------------------------
    # Create service key for Process Integration Runtime
    # ------------------------------------------------------------------------------------------------------
    resource "cloudfoundry_service_credential_binding" "cpi_rt_key" {
      type             = "key"
      name             = "cpi-rt-key"
      service_instance = cloudfoundry_service_instance.it_rt__integration_flow.id
    }

    # ------------------------------------------------------------------------------------------------------
    # Create destination service + RFC destination to S/4HANA
    # ------------------------------------------------------------------------------------------------------
    data "cloudfoundry_service" "destination_service_plans" {
      name = "${let.destinationsrvcname}"
    }

    resource "cloudfoundry_service_instance" "destination__lite" {
      depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer]
      name         = "cpi-destination"
      space        = cloudfoundry_space.cf_space.id
      service_plan = data.cloudfoundry_service.destination_service_plans.service_plans["${let.destinationsrvcplanname}"]
      type         = "managed"
      parameters = jsonencode({
        "HTML5Runtime_enabled" : "true",
        "init_data" : {
          "instance" : {
            "existing_destinations_policy" : "update",
            "destinations" : [
              {
                "AuthorizationType" = "CONFIGURED_USER",
                "Name"              = "SID_RFC",
                "Description"       = "SAP S/4HANA Connection via RFC",
                "ProxyType"         = "OnPremise",
                "Type"              = "RFC",
                "User"              = "BPINST"
                "Password"          = "${var.s4_connection_pw}"
                "jco.client.ashost" = "your-virtual-host-name"
                "jco.client.client" = "100"
                "jco.client.lang"   = "EN"
                "jco.client.sysnr"  = "00"
              }
            ]
          }
        }
      })
    }

  }
}
