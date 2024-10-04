# SAP Integration Suite starter-set with Terraform

This repository contains a starter-set for the setup of the SAP Integration Suite on SAP BTP leveraging Terraform.

## Setup process

The setup process comprises two steps:

1. The setup of the SAP BTP specific resources. This comprises the setup of the Cloud Foundry Environment
1. The setup of the Cloud Foundry specific role, service instances and service bindings.

> [!IMPORTANT]
> The Terraform provider for Cloud Foundry needs the API endpoint for authentication. This endpoint is an outcome of the setup of the CF environment on SAP BTP. Hence, the overall setup is a two-step process.

> [!TIP]
> To make the setup a bit more convenient you can create a `terraform.tfvars` file as outcome of the SAP BTP setup in the directory for the Cloud Foundry setup. This file contains all the relevant information for the Cloud Foundry specific setup and makes the process a bit smoother compared to a manual feed of the results of the BTP setup into the Cloud Foundry setup.
>
> However for a CI/CD pipeline we also provide the relevant information as outputs, so that these can be used in an automated process.

## Getting started

To get started with the setup of the SAP Integration Suite on SAP BTP leveraging Terraform, follow the steps below:

1. Ensure terraform is installed on your machine. You can download Terraform from the [official website](https://www.terraform.io/downloads.html). Or leverage the devcontainer in this repository.
1. Clone this repository to your local machine.
1. Navigate to the `sap-btp-setup` directory.
1. Run `terraform init` to initialize the Terraform configuration.
1. Run `terraform apply` to apply the Terraform configuration.

## Contributing

If you want to contribute to this repository, please open an issue or a pull request.
