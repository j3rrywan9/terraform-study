# Terraform: Up and Running

## Deploying a Single Server

Terraform code is written in the *HashiCorp Configuration Language (HCL)* in files with the extension *.tf*.
It is a declarative language, so your goal is to describe the infrastructure you want, and Terraform will figure out how to create it.
Terraform can create infrastructure across a wide variety of platforms, or what it calls *providers*.

The firsts step to using Terraform is typically to configure the provider(s) you want to use.
```terraform
provider "aws" {
  region = "us-east-1"
}
```
This tells Terraform that you are going to be using AWS as your provider and that you wish to deploy your infrastructure into the **us-east-1** region.

