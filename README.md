# SAP Integration Suite starter-set with Terraform

This repository contains a starter-set for the setup of the SAP Integration Suite on SAP BTP leveraging Terraform and Terramate.

## Setup process

The setup process comprises of three steps:

1. The setup of the SAP BTP specific resources. This comprises the setup of the Cloud Foundry Environment and Integration Suite provisioning role assignments.
1. The provisioning of the SAP Cloud Integration capability of Integration Suite on SAP BTP.
1. The setup of the Cloud Foundry specific role, service instances and service bindings.

> [!IMPORTANT]
> The Terraform provider for Cloud Foundry needs the API endpoint for authentication. This endpoint is an outcome of the setup of the CF environment on SAP BTP. Hence, the overall setup is a two-step process.

> [!TIP]
> To make the setup a bit more convenient you can generate a `terraform.tfvars` file as outcome of the SAP BTP setup in the directory for the Cloud Foundry setup. This file contains all the relevant information for the Cloud Foundry specific setup and makes the process a bit smoother compared to a manual feed of the results of the BTP setup into the Cloud Foundry setup.
>
> However for a CI/CD pipeline we also provide the relevant information as outputs, so that these can be used in an automated process.

## Getting started

To get started with the setup of the SAP Integration Suite on SAP BTP leveraging Terraform, follow the steps below:

_Ensure terraform and terramate is installed on your machine. You can download Terraform from the [official website](https://www.terraform.io/downloads.html) and Terramate from GitHub [here](https://github.com/terramate-io/terramate/releases). Or leverage the devcontainer in this repository._

### Setup Terramate

You have the option top deploy the setup either in a productive or a trial landscape of SAP BTP. Both options are available in different [Terramate](https://terramate.io/) stacks.

### Step 1: Setup of the SAP BTP environment

1. Clone [this repository](https://github.com/MartinPankraz/sap-is-starter-pack-tf.git) to your local machine.
1. Navigate to the `btp-setup` directory within the terramate stack of your choice.
1. Use the `terraform.tfvars.sample` file to create a `terraform.tfvars` file with your details. Start with the global account trial subdomain, which ends with "-ga" and continue from there.
1. Provide your BTP and CF credential (S-User password) as environment variable to avoid maintaining it as plain text variable on tfvars.

```bash
    $env:BTP_PASSWORD='your-S-User-password'
    $env:CF_PASSWORD='your-S-User-password'
```

1. Run `terramate generate` to initialize the Terramate managed Terraform configuration.
1. To initialize the setup for the trial stacks execute the following command. Replace `trial` with `prod` for the production stacks.

```bash
terramate run -X --tags trial --parallel 2 terraform init
```

```bash
terramate run -X --tags trial:btp terraform plan
```

```bash
terramate run -X --tags --tags trial:btp terraform apply -auto-approve
```

### Step 2: Provisioning of the SAP Cloud Integration capability

1. Navigate to your new `integration-suite` instance and follow the "Activate the capabilities" section of [this official SAP guide](https://developers.sap.com/tutorials/btp-integration-suite-nonsapconnectivity-settingup-suite.html#2dd341be-0d15-4d82-9143-479a059763e7) to provision the SAP Cloud Integration capability.
1. Once the provisioning is done, you can proceed with the setup of the Cloud Foundry environment including the new role collections for Integration Suite (PI_Administrator,PI_Business_Expert,PI_Integration_Developer). Otherwise, step 3 will fail.

### Step 3: Setup of the Cloud Foundry environment

To conclude the setup with the newly provisioned role collections for Integration Suite execute the following commands. Again, replace `trial` with `prod` for the production stacks.

```bash
terramate run -X --tags trial:cf terraform plan
```

```bash
terramate run -X --tags trial:cf terraform apply -auto-approve
```

Verify the SAP Process Integration Runtime was created successfully by checking the service instances in the Cloud Foundry environment, its generated service key, and the Destination named "SID_RFC" from the BTP portal. Check the instance details area that opens to the right, select the Actions menu using the button with the three dots `...` .

Happy integrating with SAP BTP!

## Contributing

If you want to contribute to this repository, please open an issue or a pull request.
