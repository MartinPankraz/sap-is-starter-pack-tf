generate_file "_terramate_terraform.tfvars.sample" {
  stack_filter {
    project_paths = [
      "stacks/prod/btp*",
      "stacks/trial/btp*",
    ]
  }

  lets {
    trialplaceholder = tm_ternary(tm_contains(terramate.stack.tags, "trial"), "subdomain-of-SAP-BTP-trial-globalaccount", "subdomain-of-SAP-BTP-globalaccount")
  }

  content = <<-EOF
    # Use this file to configure the BTP setup. Rename this file to terraform.tfvars and fill in the values for the variables.
    globalaccount            = "${let.trialplaceholder}"
    parent_id                = ""
    btp_username             = "email-associated-with-s-user-id@your-company.com"
    integration_provisioners = ["email-associated-with-s-user-id@your-company.com"]
    pi_administrator         = ["email-associated-with-s-user-id@your-company.com"]
    pi_business_expert       = ["email-associated-with-s-user-id@your-company.com"]
    pi_integration_developer = ["email-associated-with-s-user-id@your-company.com"]
    cf_org_admins            = []
    cf_org_users             = []
    cf_space_developers      = ["email-associated-with-s-user-id@your-company.com"]
    cf_space_managers        = ["email-associated-with-s-user-id@your-company.com"]
    cf_org_name              = "sap_is_test_cf"
    # Available trial regions: ap21, us10
    region           = "ap21"
  EOF
}
