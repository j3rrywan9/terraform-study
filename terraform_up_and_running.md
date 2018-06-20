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

For each type of provider, there are many different kinds of *resources* you can create, such as servers, databases, and load balancers.

The general syntax for a Terraform resource is:
```terraform
resource "PROVIDER_TYPE" "NAME" {
  [CONFIG ...]
}
```
where `PROVIDER` is the name of a provider (e.g., `aws`), `TYPE` is the type of resources to create in that provider (e.g., `instance`), `NAME` is an identifier you can use throughout the Terraform code to refer to this resource (e.g., `example`), and `CONFIG` consists of one or more configuration parameters that are specific to that resource (e.g., `ami = "ami-40d28157"`).

The `plan` command lets you see what Terraform will do before actually making any changes.
This is a great way to sanity check your code before unleashing it onto the world.
The output of the `plan` command is similar to the output of the `diff` command that is part of Unix, Linux, and `git`:
resources with a plus sign (`+`) are going to be created, resources with a minus sign (`-`) are going to be deleted, and resources with a tilde sign (`~`) are going to be modified.

The actually create the instance, run the `terraform apply` command.

Now that you have some working Terraform code, you may want to store it in version control.
This allows you to share your code with other team members, track the history of all infrastructure changes, and use the commit log for debugging.

