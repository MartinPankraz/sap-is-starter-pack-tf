generate_hcl "_terramate_generated_main_btp.tf" {
  stack_filter {
    project_paths = [
      "stacks/prod/btp*",
      "stacks/trial/btp*",
    ]
  }

  lets {
    cloudfoundryplan             = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "trial", "standard")
    integrationsuitesrvcname     = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "integrationsuite-trial", "integrationsuite")
    integrationsuitesrvcplanname = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "trial", "standard_edition")
    destinationsrvcname          = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "destination", "destination")
    destinationsrvcplanname      = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "lite", "lite")
  }

  content {
    # ------------------------------------------------------------------------------------------------------
    # Define local variables
    # For consistent labeling consider using the module https://registry.terraform.io/modules/cloudposse/label/null/latest
    # ------------------------------------------------------------------------------------------------------
    resource "random_uuid" "uuid" {}

    locals {
      random_uuid          = random_uuid.uuid.result
      subaccount_subdomain = lower("${var.subaccount_subdomain_prefix}-${local.random_uuid}")
      subaccount_name      = var.subaccount_name != "" ? var.subaccount_name : "${var.subaccount_subdomain_prefix}-${local.random_uuid}"
      subaccount_cf_org    = length(var.cf_org_name) > 0 ? var.cf_org_name : substr(replace("${local.subaccount_subdomain}", "-", ""), 0, 32)
    }

    # ------------------------------------------------------------------------------------------------------
    # Create subaccount
    # ------------------------------------------------------------------------------------------------------
    resource "btp_subaccount" "integration_suite" {
      name      = local.subaccount_name
      subdomain = local.subaccount_subdomain
      region    = lower(var.region)
    }

    # ------------------------------------------------------------------------------------------------------
    # Set all entitlements in the subaccount
    # ------------------------------------------------------------------------------------------------------
    module "sap-btp-entitlements" {
      source  = "${global.terraform.modules.btp_entitlement.source}"
      version = "${global.terraform.modules.btp_entitlement.version}"

      subaccount = btp_subaccount.integration_suite.id

      entitlements = var.entitlements
    }

    # ------------------------------------------------------------------------------------------------------
    # Create Integration Suite for BTP
    # ------------------------------------------------------------------------------------------------------

    resource "btp_subaccount_subscription" "integrationsuite" {
      subaccount_id = btp_subaccount.integration_suite.id
      app_name      = "${let.integrationsuitesrvcname}"
      plan_name     = "${let.integrationsuitesrvcplanname}"
      depends_on    = [module.sap-btp-entitlements]
    }

    # ------------------------------------------------------------------------------------------------------
    # Assign the provisioner roles to the users
    # ------------------------------------------------------------------------------------------------------
    resource "btp_subaccount_role_collection_assignment" "Integration_Provisioner" {
      for_each             = toset(var.integration_provisioners)
      user_name            = each.value
      subaccount_id        = btp_subaccount.integration_suite.id
      role_collection_name = "Integration_Provisioner"
      depends_on           = [btp_subaccount_subscription.integrationsuite]
    }

    # ------------------------------------------------------------------------------------------------------
    # Create Cloud Foundry environment instance
    # ------------------------------------------------------------------------------------------------------
    data "btp_subaccount_environments" "all" {
      subaccount_id = btp_subaccount.integration_suite.id
    }

    resource "terraform_data" "cf_landscape_label" {
      input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
    }

    # ------------------------------------------------------------------------------------------------------
    # Create CF instance for BTP trial landscapes
    # ------------------------------------------------------------------------------------------------------

    resource "btp_subaccount_environment_instance" "cloudfoundry" {
      subaccount_id    = btp_subaccount.integration_suite.id
      name             = var.instance_name
      environment_type = "cloudfoundry"
      service_name     = "cloudfoundry"
      plan_name        = "${let.cloudfoundryplan}"
      landscape_label  = terraform_data.cf_landscape_label.output

      parameters = jsonencode({
        instance_name = local.subaccount_cf_org
      })
    }

    # ------------------------------------------------------------------------------------------------------
    # Assign the subaccount roles to the users
    # ------------------------------------------------------------------------------------------------------
    resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
      for_each             = toset(var.subaccount_admins)
      user_name            = each.value
      subaccount_id        = btp_subaccount.integration_suite.id
      role_collection_name = "Subaccount Administrator"
    }


    # ------------------------------------------------------------------------------------------------------
    # Create destination service + RFC destination to S/4HANA
    # ------------------------------------------------------------------------------------------------------
    data "btp_subaccount_service_plan" "destination" {
      subaccount_id = btp_subaccount.integration_suite.id
      offering_name = "${let.destinationsrvcname}"
      name          = "${let.destinationsrvcplanname}"
      depends_on    = [module.sap-btp-entitlements]
    }

    resource "btp_subaccount_service_instance" "destination" {
      subaccount_id  = btp_subaccount.integration_suite.id
      serviceplan_id = data.btp_subaccount_service_plan.destination.id
      name           = "cpi-destination"
      depends_on     = [data.btp_subaccount_service_plan.destination]
      parameters = jsonencode({
        "HTML5Runtime_enabled" : "true",
        "init_data" : {
          "subaccount" : {
            "existing_destinations_policy" : "update",
            "destinations" : [
              {
                "Name"              = "SID_RFC",
                "Type"              = "RFC",
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

    # ------------------------------------------------------------------------------------------------------
    # Write output variables to local file
    # ------------------------------------------------------------------------------------------------------
    resource "local_file" "output_vars_step1" {
      count    = var.create_tfvars_file_for_cf ? 1 : 0
      content  = <<-EOT
      globalaccount        = "${var.globalaccount}"
      btp_username         = "${var.btp_username}"
      subaccount_id        = "${btp_subaccount.integration_suite.id}"
      pi_administrator     = ${jsonencode(var.pi_administrator)}
      pi_business_expert   = ${jsonencode(var.pi_business_expert)}
      pi_integration_developer = ${jsonencode(var.pi_integration_developer)}
      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
      cf_org_id            = "${btp_subaccount_environment_instance.cloudfoundry.platform_id}"
      cf_space_name        = "${var.cf_space_name}"
      cf_org_admins        = ${jsonencode(var.cf_org_admins)}
      cf_org_users         = ${jsonencode(var.cf_org_users)}
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}
      s4_connection_pw     = "${var.s4_connection_pw}"
      EOT
      filename = "../cf-setup/terraform.tfvars"
    }

  }
}
