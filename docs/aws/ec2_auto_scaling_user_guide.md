# Amazon EC2 Auto Scaling User Guide

## What is Amazon EC2 Auto Scaling?

Amazon EC2 Auto Scaling helps you ensure that you have the correct number of Amazon EC2 instances available to handle the load for your application.
You create collections of EC2 instances, called *Auto Scaling groups*.
You can specify the minimum number of instances in each Auto Scaling group, and Amazon EC2 Auto Scaling ensures that your group never goes below this size.
You can specify the maximum number of instances in each Auto Scaling group, and Amazon EC2 Auto Scaling ensures that your group never goes above this size.
If you specify the desired capacity, either when you create the group or at any time thereafter, Amazon EC2 Auto Scaling ensures that your group has this many instances.
If you specify scaling policies, then Amazon EC2 Auto Scaling can launch or terminate instances as demand on your application increases or decreases.

## Launch templates

A launch template is similar to a launch configuration, in that it specifies instance configuration information.
It includes the ID of the Amazon Machine Image (AMI), the instance type, a key pair, security groups, and other parameters used to launch EC2 instances.
However, defining a launch template instead of a launch configuration allows you to have multiple versions of a launch template.

## Auto Scaling groups

An *Auto Scaling group* contains a collection of Amazon EC2 instances that are treated as logical grouping for the purposes of automatic scaling and management.

### Creating an Auto Scaling group using a launch template

To configure Amazon EC2 instances that are launched by your Auto Scaling group, you can specify a launch template, a launch configuration, or an EC2 instance.
The following procedure demonstrates how to create an Auto Scaling group using a launch template.

With launch templates, you can configure the Auto Scaling group to dynamically choose either the default version or the latest version of the launch template when a scale-out event occurs.
For example, you configure your Auto Scaling group to choose the current default version of a launch template.
To change the configuration of the EC2 instances to be launched by the group, create or designate a new default version of the launch template.
Alternatively, you can choose the specific version of the launch template that the group uses to launch EC2 instances.
You can change these selections anytime by updating the group.

### Elastic Load Balancing and Amazon EC2 Auto Scaling

Elastic Load Balancing automatically distributes your incoming application traffic across all the EC2 instances that you are running.
Elastic Load Balancing helps to manage incoming requests by optimally routing traffic so that no one instance is overwhelmed. 

To use Elastic Load Balancing with your Auto Scaling group, attach the load balancer to your Auto Scaling group.
This registers the group with the load balancer, which acts as a single point of contact for all incoming web traffic to your Auto Scaling group. 

When you use Elastic Load Balancing with your Auto Scaling group, it's not necessary to register individual EC2 instances with the load balancer.
Instances that are launched by your Auto Scaling group are automatically registered with the load balancer.
Likewise, instances that are terminated by your Auto Scaling group are automatically deregistered from the load balancer. 

After attaching a load balancer to your Auto Scaling group, you can configure your Auto Scaling group to use Elastic Load Balancing metrics (such as the Application Load Balancer request count per target) to scale the number of instances in the group as demand fluctuates.

Optionally, you can add Elastic Load Balancing health checks to your Auto Scaling group so that Amazon EC2 Auto Scaling can identify and replace unhealthy instances based on these additional health checks.
Otherwise, you can create a CloudWatch alarm that notifies you if the healthy host count of the target group is lower than allowed. 

## Scaling the size of your Auto Scaling group

### Scaling options

Amazon EC2 Auto Scaling provides several ways for you to scale your Auto Scaling group.
