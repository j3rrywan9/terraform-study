# Terraform: Up and Running, 2nd Edition

## Preface

Terraform is an open source tool created by HashiCorp that allows you to define your infrastructure as code using a simple, declarative language and to deploy and manage that infrastructure across a variety of public cloud providers (e.g., Amazon Web Services, Microsoft Azure, Google Cloud Platform, DigitalOcean) and private cloud and virtualization platforms (e.g., OpenStack, VMWare) using a few commands.

## Chapter 1. Why Terraform

*Software delivery* consists of all of the work you need to do to make the code available to a customer, such as running that code on production servers, making the code resilient to outages and traffic spikes, and protecting the code from attackers.
Before you dive into the details of Terraform, it's worth taking a step back to see where Terraform fits into the bigger picture of software delivery.

### The Rise of DevOps

This works well for a while, but as the company grows, you eventually run into problems.
It typically plays out like this: because releases are done manually, as the number of servers increases, releases become slow, painful, and unpredictable.
The Ops team occasionally makes mistakes, so you end up with *snowflake servers*, wherein each one has a subtly different configuration from all the others (a problem known as *configuration drift*).

Nowadays, a profound shift is taking place.
Instead of managing their own datacenters, many companies are moving to the cloud, taking advantage of services such as Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP).
Instead of investing heavily in hardware, many Ops teams are spending all their time working on software, using tools such as Chef, Puppet, Terraform, and Docker.
Instead of racking servers and plugging in network cables, many sysadmins are writing code.

As a result, both Dev and Ops spend most of their time working on software, and the distinction between the two teams is blurring.
It might still make sense to have a separate Dev team responsible for the application code and an Ops team responsible for the operational code, but it's clear that Dev and Ops need to work more closely together.
This is where the *DevOps movement* comes from.

DevOps isn't the name of a team or a job title or a particular technology.
Instead, it's a set of processes, ideas, and techniques.

There are four core values in the DevOps movement: culture, automation, measurement, and sharing (sometimes abbreviated as the acronym CAMS).

### What Is Infrastructure as Code?

The idea behind infrastructure as code (IAC) is that you write and execute code to define, deploy, update, and destroy your infrastructure.
This represents an important shift in mindset in which you treat all aspects of operations as software - even those aspects that represent hardware (e.g., setting up physical servers).
In fact, a key insight of DevOps is that you can manage almost everything in code, including servers, databases, networks, log files, application configuration, documentation, automated tests, deployment processes, and so on.

#### Ad Hoc Scripts

#### Configuration Management Tools

Chef, Puppet, Ansible, and SaltStack are all *configuration management tools*, which means that they are designed to install and manage software on existing servers.

#### Server Templating Tools

#### Orchestration Tools

#### Provisioning Tools

### The Benefits of Infrastructure as Code

### How Terraform Works

How does Terraform know what API calls to make?
The answer is that you create *Terraform configurations*, which are text files that specify what infrastructure you want to create.
These configurations are the "code" in "infrastructure as code."

### How Terraform Compares to Other IaC Tools

#### Master Versus Masterless

#### Agent Versus Agentless

Ansible, CloudFormation, Heat, and Terraform do not require you to install any extra agents.

#### Large Community Versus Small Community

That said, a few trends are obvious.
First, all of the IaC tools in this comparison are open source and work with many cloud providers, except for CloudFormation, which is closed source, and works only with AWS.
Second, Ansible leads the pack in terms of popularity, with Salt and Terraform not too far behind.

## Chapter 2. Getting Started with Terraform

Terraform can provision infrastructure across public cloud providers such as Amazon Web Services (AWS), Azure, Google Cloud, and DigitalOcean, as well as private cloud and virtualization platforms such as OpenStack and VMWare.
For just about all of the code examples in this chapter and the rest of the book, you are going to use AWS.

### Setting Up Your AWS Account

To create a more-limited user account, you will need to use the *Identity and Access Management* (IAM) service.
IAM is where you manage user accounts as well as the permissions for each user.

To give an IAM user permissions to do something, you need to associate one or more IAM Policies with that user's account.
An *IAM Policy* is a JSON document that defines what a user is or isn't allowed to do.
You can create your own IAM Policies or use some of the predefined IAM Policies, which are known as *Managed Policies*.

### Install Terraform


### Deploy a Single Server

Terraform code is written in the *HashiCorp Configuration Language* (HCL) in files with the extension *.tf*.
It is a declarative language, so your goal is to describe the infrastructure you want, and Terraform will figure out how to create it.
Terraform can create infrastructure across a wide variety of platforms, or what it calls *providers*, including AWS, Azure, Google Cloud, DigitalOcean, and many others.

The firsts step to using Terraform is typically to configure the provider(s) you want to use.
Create an empty folder and put a file in it called *main.tf* that contains the following contents:
```terraform
provider "aws" {
  region = "us-east-2"
}
```
This tells Terraform that you are going to be using AWS as your provider and that you wish to deploy your infrastructure into the `us-east-2` region.
AWS has datacenters all over the world, grouped into regions.
An *AWS region* is a separate geographic area, such as `us-east-2` (Ohio), `eu-west-1` (Ireland), and `ap-southeast-2` (Sydney).
Within each region, there are multiple isolated datacenters known as *Availability Zones* (AZs), such as `us-east-2a`, `us-east-2b`, and so on.

For each type of provider, there are many different kinds of *resources* you can create, such as servers, databases, and load balancers.
The general syntax for a resource in Terraform is:
```terraform
resource "<PROVIDER>_<TYPE>" "<NAME>" {
  [CONFIG ...]
}
```
where `PROVIDER` is the name of a provider (e.g., `aws`), `TYPE` is the type of resources to create in that provider (e.g., `instance`), `NAME` is an identifier you can use throughout the Terraform code to refer to this resource (e.g., `my_instance`), and `CONFIG` consists of one or more *arguments* that are specific to that resource.

In a terminal, go into the folder where you created main.tf and run the `terraform init` command:
```
terraform init
```
The `terraform` binary contains the basic functionality for Terraform, but it does not come with the code for any of the providers (e.g., the AWS provider, Azure provider, GCP provider, etc.), so when you're first starting to use Terraform, you need to run `terraform init` to tell Terraform to scan the code, figure out which providers you're using, and download the code for them.

Now that you have the provider code downloaded, run the `terraform plan` command:
```
terraform plan
```
The `plan` command lets you see what Terraform will do before actually making any changes.
This is a great way to sanity check your code before unleashing it onto the world.
The output of the `plan` command is similar to the output of the `diff` command that is part of Unix, Linux, and `git`:
anything with a plus sign (`+`) are going to be created, anything with a minus sign (`-`) are going to be deleted, and anything with a tilde sign (`~`) are going to be modified in place.

To actually create the instance, run the `terraform apply` command:
```
terraform apply
```
Now that you have some working Terraform code, you may want to store it in version control.
This allows you to share your code with other team members, track the history of all infrastructure changes, and use the commit log for debugging.

## Deploy a Single Web Server

How do you get the EC2 Instance to run this script?
Normally, as discussed in "Server Templating Tools", you would use a tool like Packer to create a custom AMI that has the web server installed on it.
Since the dummy web server in this example is just a one-liner that uses `busybox`, you can use a plain Ubuntu 18.04 AMI, and run the "Hello, World" script as part of the EC2 Instance's *User Data* configuration.
When you launch an EC2 Instance, you have the option of passing either a shell script or cloud-init directive to User Data, and the EC2 Instance will execute it during boot.
You pass a shell script to User Data by setting the `user_data` argument in your Terraform code as follows:
```terraform
resource "aws_instance" "example" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "terraform-example"
  }
}
```
The `<<-EOF` and `EOF` are Terraform's heredoc syntax, which allows you to create multiline strings without having to insert newline characters all over the place.

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
This code creates a new resource called `aws_security_group` (notice how all resources for the AWS provider begin with `aws_`) and specifies that this group allows incoming TCP requests on port 8080 from the CIDR block 0.0.0.0/0.
*CIDR blocks* are a concise way to specify IP address ranges.
For example, a CIDR block of 10.0.0.0/24 represents all IP addresses between 10.0.0.0 and 10.0.0.255.
The CIDR block 0.0.0.0/0 is an IP address range that includes all possible IP addresses, so this security group allows incoming requests on port 8080 from any IP.

Simply creating a security group isn't enough;
you also need to tell the EC2 instance to actually use it by passing the ID of the security group into the `vpc_security_group_ids` parameter of the `aws_instance` resource.
To do that, you first need to learn about Terraform *expressions*.

An expression in Terraform is anything that returns a value.
You've already seen the simplest type of expressions, *literals*, such as strings (e.g., `"ami-0c55b159cbfafe1f0"`) and numbers (e.g., `5`).
Terraform supports many other types of expressions that you'll see throughout the book.

One particularly useful type of expression is a *reference*, which allows you to access values from other parts of your code.
To access the ID of the security group resource, you are going to need to use a resource attribute reference, which uses the following syntax:
```terraform
<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
```
where `PROVIDER` is the name of the provider (e.g., `aws`), `TYPE` is the type of resource (e.g., `security_group`), `NAME` is the name of that resource (e.g., the security group is named `"instance"`), and `ATTRIBUTE` is either one of the arguments of that resource (e.g., `name`) or one of the attributes *exported* by the resource (you can find the list of available attributes in the documentation for each resource).
The security group exports an attribute called `id`, so the expression to reference it will look like this:
```terraform
aws_security_group.instance.id
```
You can use this security group ID in the `vpc_security_group_ids` argument of the `aws_instance`:
```terraform
resource "aws_instance" "example" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags = {
    Name = "terraform-example"
  }
}
```
When you add a reference from one resource to another, you create an *implicit dependency*.
Terraform parses these dependencies, builds a dependency graph from them, and uses that to automatically determine in which order it should create resources.
For example, if you were deploying this code from scratch, Terraform would know that it needs to create the security group before the EC2 Instance, because the EC2 Instance references the ID of the security group.
You can even get Terraform to show you the dependency graph by running the `graph` command:
```
terraform graph
```

When Terraform walks your dependency tree, it creates as many resources in parallel as it can, which means that it can apply your changes fairly efficiently.
That's the beauty of a declarative language: you just specify what you want and Terraform determines the most efficient way to make it happen.

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
Here's the syntax for declaring a variable:
```terraform
variable "NAME" {
  [CONFIG ...]
}
```
The body of the variable declaration can contain three parameters, all of them optional:
* `description`
* `default`
* `type`

Here is an example of an input variable that checks to verify that the value you pass in is a number:
```terraform
variable "number_example" {
  description = "An example of a number variable in Terraform"
  type        = number
  default     = 42
}
```

To use the value from an input variable in your Terraform code, you can use a new type of expression called a *variable reference*, which has the following syntax:
```
var.<VARIABLE_NAME>
```

To extract values from these input variables in your Terraform code, you can use interpolation syntax again.
The syntax for looking up a variable is:
```terraform
"${var.VARIABLE_NAME}"
}
```

In addition to input variables, Terraform also allows you to define *output variables* by using the following syntax:
```terraform
output "<NAME>" {
  value = <VALUE>
  [CONFIG ...]
}
```
The `NAME` is the name of the output variable, and `VALUE` can be any Terraform expression that you would like to output.
The `CONFIG` can contain two additional parameters, both optional:
* `description`
* `sensitive`

## Deploying a Cluster of Web Servers

Fortunately, you can let AWS take care of it for you by using an *Auto Scaling Group (ASG)*.
An ASG takes care of a lot of tasks for you completely automatically, including launching a cluster of EC2 instances, monitoring the health of each instance, replacing failed instances, and adjusting the size of the cluster in response to load.

The first step in creating an ASG is to create a *launch configuration*, which specifies how to configure each EC2 instance in the ASG.
The `aws_launch_configuration` resource uses almost the same parameters as the `aws_instance` resource, although it doesn't support tags (we'll handle these in the aws_autoscaling_group resource later) and two of the parameters have different names (`ami` is now `image_id` and `vpc_security_group_ids` is now `security_groups`), so replace aws_instance with `aws_launch_configuration` as follows:
```terraform
```

Now you can create the ASG itself using the `aws_autoscaling_group` resource:
```terraform
```

To solve this problem, you can use a *lifecycle* setting.
Every Terraform resource supports several lifecycle settings that configure how that resource is created, updated, and/or deleted.
A particularly useful lifecycle setting is `create_before_destroy`.

One of the available `lifecycle` settings is `create_before_destroy`, which, if set to `true`, tells Terraform to always create a replacement resource before destroying the original resource.

There's also one other parameter that you need to add to your ASG to make it work: `subnet_ids`.
This parameter specifies to the ASG into which VPC subnets the EC2 Instances should be deployed (see "Network Security" for background info on subnets).
Each subnet lives in an isolated AWS AZ (that is, isolated datacenter), so by deploying your Instances across multiple subnets, you ensure that your service can keep running even if some of the datacenters have an outage.
You could hardcode the list of subnets, but that won't be maintainable or portable, so a better option is to use *data sources* to get the list of subnets in your AWS account. 

A *data source* represents a piece of read-only information that is fetched from the provider (in this case, AWS) every time your run Terraform.
Adding a data source to your Terraform configurations does not create anything new; it's just a way to query the provider's APIs for data.
Each Terraform provider exposes a variety of data sources.
For example, the AWS provider includes data sources to look up VPC data, subnet data, AMI IDs, IP address ranges, and the current user's identity, and much more.

The syntax for using a data source is very similar to the syntax of a resource:
```terraform
data "<PROVIDER>_<TYPE>" "<NAME>" {
  [CONFIG ...]
}
```
Here, `PROVIDER` is the name of a provider (e.g., `aws`), `TYPE` is the type of data source you want to use (e.g., `vpc`), `NAME` is an identifier you can use throughout the Terraform code to refer to this data source, and `CONFIG` consists of one or more arguments that are specific to that data source.
For example, here is how you can use the `aws_vpc` data source to look up the data for your Default VPC:
```terraform
data "aws_vpc" "default" {
  default = true
}
```
Note that with data sources, the arguments you pass in are typically search filters that indicate to the data source what information you're looking for.
With the `aws_vpc` data source, the only filter you need is `default = true`, which directs Terraform to look up the Default VPC in your AWS account.

To get the data out of a data source, you use the following attribute reference syntax:
```terraform
data.<PROVIDER>_<TYPE>.<NAME>.<ATTRIBUTE>
```

## Deploying a Load Balancer

At this point, you can deploy your ASG, but you'll have a small problem: you now have multiple servers, each with its own IP address, but you typically want to give of your end users only a single IP to use. 
One way to solve this problem is to deploy a *load balancer* to distribute traffic across your servers and to give all your users the IP (actually, the DNS name) of the load balancer.

AWS offers three different types of load balancers:
* Application Load Balancer (ALB)

Best suited for load balancing of HTTP and HTTPS traffic.
Operates at the application layer (Layer 7) of the OSI model.
* Network Load Balancer (NLB)
* Classic Load Balancer (CLB)

Most applications these days should use either the ALB or the NLB.
Because the simple web server example you're working on is an HTTP app without any extreme performance requirements, the ALB is going to be the best fit.

Note that, by default, all AWS resources, including ALBs, don't allow any incoming or outgoing traffic, so you need
to create a new security group specifically for the ALB.
This security group should allow incoming requests on port 80 so that you can access the load balancer over HTTP, and outgoing requests on all ports so that the load balancer can perform health checks:

## Cleanup

When you're done experimenting with Terraform, either at the end of this chapter, or at the end of future chapters, it's a good idea to remove all of the resources you created so that AWS doesn't charge you for them.

Since Terraform keeps track of what resources you created, cleanup is simple.
All you need to do is run the destroy command:
```terraform
terraform destroy
```

## Chapter 3. How to Manage Terraform State

### What Is Terraform State?

Every time you run Terraform, it records information about what infrastructure it created in a *Terraform state* file.
By default, when you run Terraform in the folder */foo/bar*, Terraform creates the file */foo/bar/terraform.tfstate*.
This file contains a custom JSON format that records a mapping from the Terraform resources in your configuration files
to the representation of those resources in the real world.

Every time you run Terraform, it can fetch the latest status of this EC2 Instance from AWS and compare that to what's in your Terraform configurations to determine what changes need to be applied.
In other words, the output of the `plan` command is a diff between the code on your computer and the infrastructure deployed in the real world, as discovered via IDs in the state file.

If you're using Terraform for a personal project, storing state in a single *terraform.tfstate* file that lives locally on your computer works just fine.
But if you want to use Terraform as a team on a real product, you run into several problems: 
* Shared storage for state files:
To be able to use Terraform to update your infrastructure, each of your team members needs access to the same Terraform state files.
That means you need to store those files in a shared location. 
* Locking state files:
As soon as data is shared, you run into a new problem: locking.
Without locking, if two team members are running Terraform at the same time, you can run into race conditions as multiple Terraform processes make concurrent updates to the state files, leading to conflicts, data loss, and state file corruption. 
* Isolating state files:
When making changes to your infrastructure, it's a best practice to isolate different environments.
For example, when making a change in a testing or staging environment, you want to be sure that there is no way you can accidentally break production.
But how can you isolate your changes if all of your infrastructure is defined in the same Terraform state file?

In the following sections, I'll dive into each of these problems and show you how to solve them.

### Shared Storage for State Files

Instead of using version control, the best way to manage shared storage for state files is to use Terraform's built-in
support for remote backends.
A Terraform *backend* determines how Terraform loads and stores state.
The default backend, which you've been using this entire time, is the *local backend*, which stores the state file on your local disk.
*Remote backends* allow you to store the state file in a remote, shared store.
A number of remote backends are supported,
including Amazon S3; Azure Storage; Google Cloud Storage; and HashiCorp's Terraform Cloud, Terraform Pro, and Terraform Enterprise.

Remote backends solve all three of the issues just listed:
* Manual error
* Locking
* Secrets

### Isolating State Files


The whole point of having separate environments is that they are isolated from each other, so if you are managing all the environments from a single set of Terraform configurations, you are breaking that isolation.

As Figure 3-3 illustrates, instead of defining all your environments in a single set of Terraform configurations (top), you want to define each environment in a separate set of configurations (bottom), so a problem in one environment is completely isolated from the others.
There are two ways you could isolate state files: 
* Isolation via workspaces
* Isolation via file layout

#### Isolation via workspaces

*Terraform workspaces* allow you to store your Terraform state in multiple, separate, named workspaces.
Terraform starts with a single workspace called "default," and if you never explicitly specify a workspace, the default workspace is the one you'll use the entire time.
To create a new workspace or switch between workspaces, you use the `terraform workspace` commands. 

Terraform workspaces can be a great way to quickly spin up and tear down different versions of your code, but they have
a few drawbacks: 
* The state files for all of your workspaces are stored in the same backend.
* Workspaces are not visible in the code or on the terminal unless you run `terraform workspace` commands.

#### Isolation via File Layout

To acheive full isolation between environments, you need to do the following: 
* Put the Terraform configuration files for each environment into a separate folder.
* Configure a different backend for each environment, using different authentication mechanisms and access controls (e.g., each environment could live in a separate AWS account with a separate S3 bucket as a backend).

With this approach, the use of separate folders makes it much clearer which environments you're deploying to, and the use of separate state files, with separate authentication mechanisms, makes it significantly less likely that a screw up in one environment can have any impact on another. 

In fact, you might want to take the isolation concept beyond environments and down to the "component" level, where a component is a coherent set of resources that you typically deploy together.
For example, after you’ve set up the basic network topology for your infrastructure in AWS lingo, your Virtual Private Cloud (VPC) and all the associated subnets, routing rules, VPNs, and network ACLs you will probably change it only once every few months, at most.
On the other hand, you might deploy a new version of a web server multiple times per day.
If you manage the infrastructure for both the VPC component and the web server component in the same set of Terraform configurations, you are
unnecessarily putting your entire network topology at risk of breakage (e.g., from a simple typo in the code or someone accidentally running the wrong command) multiple times per day.

Therefore, I recommend using separate Terraform folders (and therefore separate state files) for each environment (staging, production, etc.) and for each component (VPC, services, databases).
To see what this looks like in practice, let's go through the recommended file layout for Terraform projects. 

At the top level, there are separate folders for each "environment."

Within each environment, there are separate folders for each "component".
The components differ for every project, but here are the typical ones:
* vpc
* services
* data-storage

Within each component, there are the actual Terraform configuration files, which are organized according to the following naming conventions:
* variables.tf: Input variables.
* outputs.tf: Output variables.
* main.tf: The actual resources.

This file layout makes it easy to browse the code and understand exactly what components are deployed in each environment.
It also provides a good amount of isolation between environments and between components within an environment, ensuring that if something goes wrong, the damage is contained as much as possible to just one small part of your entire infrastructure. 

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

## Chapter 4. How to Create Reusable Infrastructure with Terraform Modules

With Terraform, you can put your code inside of a *Terraform module* and reuse that module in multiple places throughout your code.

This is a big deal.
Modules are the key ingredient to writing reusable, maintainable, and testable Terraform code.
Once you start using them, there's no going back.
You'll start building everything as a module, creating a library of modules to share within your company, using modules that you find online, and thinking of your entire infrastructure as a collection of reusable modules. 

### Module Basics

A Terraform module is very simple: any set of Terraform configuration files in a folder is a module.
All of the configurations you've written so far have technically been modules, although not particularly interesting ones, since you deployed them directly (the module in the current working directory is called the root module ).
To see what modules are really capable of, you need to use one module from another module. 

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

