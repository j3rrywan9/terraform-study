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

Fortunately, you can let AWS take care of it for you by using an *Auto Scaling Group (ASG)*.
An ASG takes care of a lot of tasks for you completely automatically, including launching a cluster of EC2 instances, monitoring the health of each instance, replacing failed instances, and adjusting the size of the cluster in response to load.

The first step in creating an ASG is to create a *launch configuration*, which specifies how to configure each EC2 instance in the ASG.

The `lifecycle` parameter is an example of a *meta-parameter*, or a parameter that exists on just about every resource in Terraform.
You can add a `lifecycle` block to any resource to configure how that resource should be created, updated,or destroyed.

One of the available `lifecycle` settings is `create_before_destroy`, which, if set to `true`, tells Terraform to always create a replacement resource before destroying the original resource.

A *data source* represents a piece of read-only information that is fetched from the provider (in this case, AWS) every time your run Terraform.
Adding a data source to your Terraform configurations does not create anything new; it’s just a way to query the provider’s APIs for data.
There are data sources to not only get the list of availability zones, but also AMI IDs, IP address ranges, and the current user’s identity.

To use the data source, you reference it using the following syntax:
```terraform
"${data.TYPE.NAME.ATTRIBUTE}"
```

## Deploy a Load Balancer

One way to solve this problem is to deploy a *load balancer* to distribute traffic across your servers and to give all your users the IP (actually, the DNS name) of the load balancer.

## Cleanup

Since Terraform keeps track of what resources you created, cleanup is simple.
All you need to do is run the destroy command:
```terraform
terraform destroy
```

The whole point of having separate environments is that they are isolated from each other, so if you are managing all the environments from a single set of Terraform configurations, you are breaking that isolation.

The way to do that is to put the Terraform configuration files for each environment into a separate folder.
That way, Terraform will use a separate state file for each environment, which makes it significantly less likely that a screw up in one environment can have any impact on anther.

Within each environment, there are separate folders for each "component".

Within each component, there are the actual Terraform configuration files, which are organized according to the following naming conventions:
* variables.tf: Input variables.
* outputs.tf: Output variables.
* main.tf: The actual resources.

For each input variable `foo` defined in your Terraform configurations, you can provideTerraform the value of this variable using the environment variable `TF_VAR_foo`.

An *interpolation function* is a function you can use within Terraform's interpolation syntax:
```terraform
"${some_function(...)}"
```

A great way to experiment with interpolation functions is to run the `terraform console` command to get an interactive console where you can try out different Terraform syntax, query the state of your infrastructure, and see the results instantly:
```bash
terraform console
```

There a number of other built-in functions that can be used to manipulate strings, numbers, lists, and maps.
One of them is the `file` interpolation function:
```terraform
"${file(PATH)}"
```
This function reads the file at `PATH` and returns its contents as a string.

The `template_file` data source has two parameters: the `template` parameter, which is a string, and the `vars` parameter, which is a map of variables.

The final step is to update the `user_data` parameter of the `aws_launch_configuration` resource to point to the `rendered` output attribute of the `template_file` data source.

## How to Create Reusable Infrastructure with Terraform Modules

With Terraform, you can put your code inside of a *Terraform module* and reuse that module in multiple places throughout your code.

### Module Basics

A Terraform module is very simple: any set of Terraform configuration files in a folder is a module.

### Module Inputs

In Terraform, modules can have input parameters, too.
To define them, you use a mechanism you're already familiar with: input variables.

The input variables are the API of the module, controlling how it will behave in different environments.

### Module Outputs

In Terraform, a module can also return values.
Again, this is done using a mechanism you already know: output variables.

You can access module output variables the same way as resource output attributes.
The syntax is:
```terraform
"${module.MODULE_NAME.OUTPUT_NAME}"
```

### Module Gotchas

#### File Paths

The catch with `file` function is that the file path you use has to be relative.

By default, Terraform interprets the path relative to the current working directory.

To solve this issue, you can use `path.module` to convert to a path that is relative to the module folder.

#### Inline Blocks

The configuration for some Terraform resources can be defined either as inline blocks or as separate resources.
When creating a module, you should always prefer using a separate resource.

#### Module Versioning

