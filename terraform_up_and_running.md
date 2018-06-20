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

## Deploying a Single Web Server

By default, AWS does not allow any incoming or outgoing traffic from an EC2 instance.
To allow the EC2 instance to receive traffic on port 8080, you need to create a *security group*:
```terraform
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```
Simply creating a security group isn't enough;
you also need to tell the EC2 instance to actually use it.
To do that, you need to pass the ID of the security group into the `vpc_security_group_ids` parameter of the `aws_instance` resource.

To get the ID of the security group, you can use *interpolation syntax*, which looks like this:
```terraform
"${something_to_interpolate}"
```
Whenever you see a dollar sign and curly braces inside of double quotes, that means Terraform is going to process the text within the curly braces in a special way.

In Terraform, every resource exposes attributes that you can access using interpolation (you can find the list of available attributes in the documentation for each resource).
The syntax is:
```terraform
"${TYPE.NAME.ATTRIBUTE}"
```
When you use interpolation syntax to have one resource reference another resource, you create an implicit dependency.
Terraform parses these dependencies, builds a dependency graph from them, and uses that to automatically figure out in what order it should create resources.

## Deploy a Configurable Web Server

To allow you to make your code more DRY and more configurable, Terraform allows you to define *input variables*.
The syntax for declaring a variable is:
```terraform
variable "NAME" {
  [CONFIG ...]
}
```
The body of the variable declaration can contain three parameters, all of them optional:
* description
* default
* type

To extract values from these input variables in your Terraform code, you can use interpolation syntax again.
The syntax for looking up a variable is:
```terraform
"${var.VARIABLE_NAME}"
}
```
In addition to input variables, Terraform also allows you to define *output variables* with the following syntax:
```terraform
output "NAME" {
  value = VALUE
}
```

## Deploy a Cluster of Web Servers

