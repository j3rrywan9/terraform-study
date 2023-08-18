# Terraform Cloud and Terraform Enterprise

## VCS Integration

### How Terraform Cloud Uses VCS Access

Most workspaces in Terraform Cloud are associated with a VCS repository, which provides Terraform configurations for that workspace.
To find out which repos are available, access their contents, and create webhooks, Terraform Cloud needs access to your VCS provider.

Although Terraform Cloud's API lets you create workspaces and push configurations to them without a VCS connection, the primary workflow expects every workspace to be backed by a repository.

### Configuring GitHub Enterprise Access

## Workspaces

Workspaces are how Terraform Cloud organizes infrastructure.

### Workspaces are Collections of Infrastructure

Working with Terraform involves managing collections of infrastructure resources, and most organizations manage many different collections.

When run locally, Terraform manages each collection of infrastructure with a persistent working directory, which contains a configuration, state data, and variables.
Since Terraform CLI uses content from the directory it runs in, you can organize infrastructure resources into meaningful groups by keeping their configurations in separate directories.

Terraform Cloud manages infrastructure collections with *workspaces* instead of directories.
A workspace contains everything Terraform needs to manage a given collection of infrastructure, and separate workspaces function like completely separate working directories.

### Workspace Contents

### Planning and Organizing Workspaces

We recommend that organizations break down large monolithic Terraform configurations into smaller ones, then assign each one to its own workspace and delegate permissions and responsibilities for them.
Terraform Cloud can manage monolithic configurations just fine, but managing infrastructure as smaller components is the best way to take full advantage of Terraform Cloud's governance and delegation features.

For example, the code that manages your production environment's infrastructure could be split into a networking configuration, the main application's configuration, and a monitoring configuration.
After splitting the code, you would create "networking-prod", "app1-prod", "monitoring-prod" workspaces, and assign separate teams to manage them.

### Creating Workspaces

Workspaces organize infrastructure into meaningful groups.
Create new workspaces whenever you need to manage a new collection of infrastructure resources.

Each new workspace needs a unique name, and needs to know where its Terraform configuration will come from.
Most commonly, the configuration comes from a connected version control repository.
If you choose not to connect a repository, you'll need to upload configuration versions for the workspace using Terraform CLI or the API.

## Users, Teams, and Organizations

Terraform Cloud's organizational and access control model is based on three units: users, teams, and organizations.
* Users are individual members of an organization.
They belong to teams, which are granted permissions on an organization's workspaces.
* Teams are groups of users that reflect your company's organizational structure.
Organization owners can create teams and manage their membership.
* Organizations are shared spaces for teams to collaborate on workspaces.
An organization can have many teams, and the owners of the organization set which teams have which permissions on which workspaces.
