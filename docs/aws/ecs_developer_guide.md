# Amazon Elastic Container Service Developer Guide

## What is Amazon Elastic Container Service?

Amazon Elastic Container Service (Amazon ECS) is a highly scalable, fast, container management service that makes it easy to run, stop, and manage containers on a cluster.
Your containers are defined in a task definition which you use to run individual tasks or as a service.
You can run your tasks and services on a serverless infrastructure that is managed by AWS Fargate or, for more control over your infrastructure, you can run your tasks and services on a cluster of Amazon EC2 instances that you manage.

### Features of Amazon ECS

Amazon ECS is a regional service that simplifies running containers in a highly available manner across multiple Availability Zones within a Region.
You can create Amazon ECS clusters within a new or existing VPC.
After a cluster is up and running, you can create task definitions that define which container images to run across your clusters.
Your task definitions are used to run tasks or create services.
Container images are stored in and pulled from container registries, for example Amazon Elastic Container Registry.

## Amazon ECS Clusters

An Amazon ECS cluster is a logical grouping of tasks or services.
Your tasks and services are run on infrastructure that is registered to a cluster.
The infrastructure capacity can be provided by AWS Fargate, which is serverless infrastructure that AWS manages, Amazon EC2 instances that you manage, or an on-premise server or virtual machine (VM) that you manage remotely.
In most cases, Amazon ECS capacity providers can be used to manage the infrastructure the tasks in your clusters use.

### Cluster concepts

The following are general concepts about Amazon ECS clusters.
* Clusters are Region-specific.
* The following are the possible states that a cluster can be in.

### Creating a cluster

#### Using the EC2 Linux + Networking or EC2 Windows + Networking template

### Amazon ECS capacity providers

Amazon ECS capacity providers are used to manage the infrastructure the tasks in your clusters use.
Each cluster can have one or more capacity providers and an optional default capacity provider strategy.
The capacity provider strategy determines how the tasks are spread across the cluster's capacity providers.
When you run a standalone task or create a service, you may either use the cluster's default capacity provider strategy or specify a capacity provider strategy that overrides the cluster's default strategy.

#### Capacity provider concepts

#### Capacity provider considerations

### Amazon ECS cluster auto scaling

Amazon ECS cluster auto scaling enables you to have more control over how you scale the Amazon EC2 instances within a cluster.
When creating an Auto Scaling group capacity provider with managed scaling enabled, Amazon ECS manages the scale-in and scale-out actions of the Auto Scaling group used when creating the capacity provider.
On your behalf, Amazon ECS creates an AWS Auto Scaling scaling plan with a target tracking scaling policy based on the target capacity value you specify.
Amazon ECS then associates this scaling plan with your Auto Scaling group.

## Amazon ECS task definitions

A task definition is required to run Docker containers in Amazon ECS.
The following are some of the parameters you can specify in a task definition:
* The Docker image to use with each container in your task
* How much CPU and memory to use with each task or each container within a task
* The launch type to use, which determines the infrastructure on which your tasks are hosted
* The Docker networking mode to use for the containers in your task

### Application architecture

### Creating a task definition

Before you can run Docker containers on Amazon ECS, you must create a task definition.
You can define multiple containers and data volumes in a single task definition.
For more information about the parameters available in a task definition, see Task definition parameters.

Using the EC2 launch type compatibility template

If you chose EC2, complete the following steps:
1. (Optional) If you have a JSON representation of your task definition, complete the following steps:

#### Task definition template

### Task definition parameters

#### Family

#### Launch types

#### Task role

### Amazon ECS launch types

#### EC2 launch type

### Amazon ECS task networking

The networking behavior of Amazon ECS tasks hosted on Amazon EC2 instances is dependent on the *network mode* defined in the task definition.
The following are the available network modes.
Amazon ECS recommends using the `awsvpc` network mode unless you have a specific need to use a different network mode.
* `awsvpc` — The task is allocated its own elastic network interface (ENI) and a primary private IPv4 address. This gives the task the same networking properties as Amazon EC2 instances.
* `bridge` — The task utilizes Docker's built-in virtual network which runs inside each Amazon EC2 instance hosting the task.
* `host` — The task bypasses Docker's built-in virtual network and maps container ports directly to the ENI of the Amazon EC2 instance hosting the task. As a result, you can't run multiple instantiations of the same task on a single Amazon EC2 instance when port mappings are used.
* `none` — The task has no external network connectivity.

#### Task networking with the `awsvpc` network mode

The task networking features provided by the `awsvpc` network mode give Amazon ECS tasks the same networking properties as Amazon EC2 instances.
Using the `awsvpc` network mode simplifies container networking and gives you more control over how containerized applications communicate with each other and other services within your VPCs.
The `awsvpc` network mode also provides greater security for your containers by enabling you to use security groups and network monitoring tools at a more granular level within your tasks.
Because each task gets its own elastic network interface (ENI), you can also take advantage of other Amazon EC2 networking features like VPC Flow Logs so that you can monitor traffic to and from your tasks.
Additionally, containers that belong to the same task can communicate over the `localhost` interface.

The task ENI is fully managed by Amazon ECS.
Amazon ECS creates the ENI and attaches it to the host Amazon EC2 instance with the specified security group.
The task sends and receives network traffic over the ENI in the same way that Amazon EC2 instances do with their primary network interfaces.
Each task ENI is assigned a private IPv4 address by default.
If your VPC is enabled for dual-stack mode and you use a subnet with an IPv6 CIDR block, the task ENI will also receive an IPv6 address.
Each task can only have one ENI.

### Specifying environment variables

## Amazon ECS container instances

An Amazon ECS container instance is an Amazon EC2 instance that is running the Amazon ECS container agent and has been registered into an Amazon ECS cluster.
When you run tasks with Amazon ECS using the EC2 launch type or an Auto Scaling group capacity provider, your tasks are placed on your active container instances.

Amazon ECS supports the following container instance types.
* Linux
* Windows
* External, such as an on-premises VM

### Container instance concepts

* Your container instance must be running the Amazon ECS container agent.
The container agent is able to register the instance into one of your clusters.
If you are using an Amazon ECS-optimized AMI, the agent is already installed.

## Amazon ECS services

An Amazon ECS service allows you to run and maintain a specified number of instances of a task definition simultaneously in an Amazon ECS cluster.
If any of your tasks should fail or stop for any reason, the Amazon ECS service scheduler launches another instance of your task definition to replace it in order to maintain the desired number of tasks in the service.

In addition to maintaining the desired number of tasks in your service, you can optionally run your service behind a load balancer.
The load balancer distributes traffic across the tasks that are associated with the service.

### Service scheduler concepts

The service scheduler is ideally suited for long running stateless services and applications.
The service scheduler ensures that the scheduling strategy you specify is followed and reschedules tasks when a task fails (for example, if the underlying infrastructure fails for some reason).
Task placement strategies and constraints can be used to customize how the scheduler places and terminates tasks.
If a task in a service stops, the scheduler launches a new task to replace it.
This process continues until your service reaches the number of desired running tasks based on the scheduling strategy (also referred to as the *service type*) that the service uses.

The service scheduler includes logic that throttles how often tasks are restarted if they repeatedly fail to start.
If a task is stopped without having entered a `RUNNING` state, determined by the task having a `startedAt` time stamp, the service scheduler starts to incrementally slow down the launch attempts and emits a service event message.
This behavior prevents unnecessary resources from being used for failed tasks, giving you a chance to resolve the issue.
After the service is updated, the service scheduler resumes normal behavior.
For more information, see Service throttle logic and Service event messages.

There are two service scheduler strategies available:
* `REPLICA` - The replica scheduling strategy places and maintains the desired number of tasks across your cluster. By default, the service scheduler spreads tasks across Availability Zones. You can use task placement strategies and constraints to customize task placement decisions.
* `DAEMON` - The daemon scheduling strategy deploys exactly one task on each active container instance that meets all of the task placement constraints that you specify in your cluster. The service scheduler evaluates the task placement constraints for running tasks and will stop tasks that do not meet the placement constraints. When using this strategy, there is no need to specify a desired number of tasks, a task placement strategy, or use Service Auto Scaling policies.

#### Daemon

The *daemon* scheduling strategy deploys exactly one task on each active container instance that meets all of the task placement constraints specified in your cluster.

#### Replica

The *replica* scheduling strategy places and maintains the desired number of tasks in your cluster.

### Additional service concepts

### Service definition parameters

A service definition defines how to run your Amazon ECS service.
The following parameters can be specified in a service definition.

#### Launch type

#### Capacity provider strategy

If a `capacityProviderStrategy` is specified, the `launchType` parameter must be omitted.
If no `capacityProviderStrategy` or `launchType` is specified, the `defaultCapacityProviderStrategy` for the cluster is used.

If specifying a capacity provider that uses an Auto Scaling group, the capacity provider must already be created.
New capacity providers can be created with the CreateCapacityProvider API operation.

#### Task definition

The number of instantiations of the specified task definition to place and keep running on your cluster.

This parameter is required if the `REPLICA` scheduling strategy is used.
If the service uses the `DAEMON` scheduling strategy, this parameter is optional.

#### Desired count



## Tutorials for Amazon ECS

### Tutorial: Using cluster auto scaling with the AWS Management Console
