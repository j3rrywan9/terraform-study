# Terraform

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently.
Terraform can manage existing and popular service providers as well as custom in-house solutions.

Configuration files describe to Terraform the components needed to run a single application or your entire datacenter.
Terraform generates an execution plan describing what it will do to reach the desired state, and then executes it to build the described infrastructure.
As the configuration changes, Terraform is able to determine what changed and create incremental execution plans which can be applied.

The infrastructure Terraform can manage includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc.

## Installation

Terraform is distributed as a binary package for all supported platforms and architecture.

To install Terraform, find the [appropriate package](https://www.terraform.io/downloads.html) for your system and download it.

## Building infrastructure

## Configuration

The set of files used to describe infrastructure in Terraform is simply known as Terraform *configuration*.

The format of the configuration files is [documented here](https://www.terraform.io/docs/configuration/).

Terraform uses text files to describe infrastructure and to set variables.
These text files are called Terraform *configuration* and end in `.tf`.

The format of the configuration files are able to be in two formats: Terraform format and JSON.
The Terraform format is more human-readable, supports comments, and is the generally recommended format for most Terraform files.

### Load Order and Semantics

### Configuration Syntax

Basic bullet point reference:
* Strings are in double quotes.

### Interpolation Syntax

You can perform simple math in interpolations.

You can escape interpolation with double dollar signs: `$${foo}` will be rendered as a literal `${foo}`.

#### Built-in Functions

Terraform ships with built-in functions.
Functions are called with the syntax `name(arg1, arg2, ...)`.

### Overrides

Terraform loads all configuration files within a directory and appends them together.
Terraform also has a concept of `overrides`, a way to create files that are loaded last and *merged* into your configuration, rather than appended.

Overrides names must be `override` or end in `_override`, excluding the extension.

Override files are loaded last in alphabetical order.

### Resources

The most important thing you'll configure with Terraform are resources.
Resources are a component of your infrastructure.

The `resource` block creates a resource of the given `TYPE` (first parameter) and `NAME` (second parameter).
The combination of the type and name must be unique.

#### Meta-parameters

#### Explicit Dependencies

#### Connection Block

Within a resource, you can optionally have a **connection block**.
Connection blocks describe to Terraform how to connect to the resource for provisioning.
This block doesn't need to be present if you're using only local provisioners, or if you're not provisioning at all.

#### Provisioners

Within a resource, you can specify zero or more **provisioner blocks**.
Provisioner blocks configure provisioners.

### Data Sources

*Data sources* allow data to be fetched or computed for use elsewhere in Terraform configuration.
Use of data sources allows Terraform configuration to build on information defined outside Terraform, or defined by another separate Terraform configuration.

### Providers

Providers are responsible in Terraform for managing the lifecycle of a resource: create, read, update, delete.

Most providers require some sort of configuration to provide authentication information, endpoint URLs, etc.
Provider configuration blocks are a way to set this information globally for all matching resources.

### Variables

### Outputs

### Local Values

Local values assign a name to an expression, that can then be used multiple times within a module.

Comparing modules to functions in a traditional programming language, if variables are analogous to function arguments and outputs are analogous to function return values then *local values* are comparable to a function's local variables.

#### Examples

Local values are defined in locals blocks:
```terraform
# Ids for multiple sets of EC2 instances, merged together
locals {
  instance_ids = "${concat(aws_instance.blue.*.id, aws_instance.green.*.id)}"
}

# A computed default name prefix
locals {
  default_name_prefix = "${var.project_name}-web"
  name_prefix         = "${var.name_prefix != "" ? var.name_prefix : local.default_name_prefix}"
}

# Local values can be interpolated elsewhere using the "local." prefix.
resource "aws_s3_bucket" "files" {
  bucket = "${local.name_prefix}-files"
  # ...
}
```

## Providers

### AWS Provider

The Amazon Web Services (AWS) provider is used to interact with the many resources supported by AWS.
The provider needs to be configured with the proper credentials before it can be used.

### Google Cloud provider

The Google Cloud provider is used to interact with Google Cloud services.
The provider needs to be configured with the proper credentials before it can be used.

Select "Compute Engine default service account" in the "Service account" dropdown, and select "JSON" as the key type.

```bash
gcloud iam service-accounts list
```

