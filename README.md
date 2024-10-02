# SAP Intgeration Suite Starter Set with Terraform

This repository contains a starter set for the setup of the SAP Integration Suite on SAP BTP leveraging Terraform.


## Setup process

The setup process comprises two steps:

1. The setup of the SAP BTP specific resources. This comprises the setup of the Cloud Foundry Environment
1. The setup of the Cloud Foundry specific role, service instances and service bindings.


> [!IMPORTANT]
> The Terraform provider for Cloud Foundry needs the API endpoint for authentication. This endpoint is an outcome of the setup of the CF environment on SAP BTP. Hence, the overall setup is a two-step process.

To make the setup a bit more convenient you can create a `terraform.tfvars` file as outcome of the SAP BTP setup in the directory for the Cloud Foundry setup. This file contains all the relevant information for the Cloud Foundry specific setup and makes the process a bit smoother compared to a manual feed of the results of the BTP setup into the Cloud Foundry setup.

However for a CI/CD pipeline we also provide the relevant information as outputs, so that these can be used in an automated process.
