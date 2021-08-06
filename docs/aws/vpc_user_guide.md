# Amazon Virtual Private Cloud User Guide

## What Is Amazon VPC?

Amazon Virtual Private Cloud (Amazon VPC) enables you to launch AWS resources into a virtual network that you've defined.
This virtual network closely resembles a traditional network that you'd operate in your own data center, with the benefits of using the scalable infrastructure of AWS.

### Amazon VPC Concepts

#### VPCs and Subnets

A *virtual private cloud* (VPC) is a virtual network dedicated to your AWS account.
It is logically isolated from other virtual networks in the AWS Cloud.
You can launch your AWS resources, such as Amazon EC2 instances, into your VPC.
You can configure your VPC by modifying its IP address range, create subnets, and configure route tables, network gateways, and security settings.

A *subnet* is a range of IP addresses in your VPC.
You can launch AWS resources into a specified subnet.
Use a public subnet for resources that must be connected to the internet, and a private subnet for resources that won't be connected to the internet.

#### Supported Platforms

#### Default and Nondefault VPCs

If your account supports the EC2-VPC platform only, it comes with a *default VPC* that has a *default subnet* in each Availability Zone.
A default VPC has the benefits of the advanced features provided by EC2-VPC, and is ready for you to use.
If you have a default VPC and don't specify a subnet when you launch an instance, the instance is launched into your default VPC without needing to know anything about Amazon VPC.

Regardless of which platforms your account supports, you can create your own VPC, and configure it as you need.
This is known as a *nondefault VPC*.
Subnets that you create in your nondefault VPC and additional subnets that you create in your default VPC are called *nondefault subnets*.

#### Accessing the Internet

You control how the instances that you launch into a VPC access resources outside the VPC.

Your default VPC includes an internet gateway, and each default subnet is a public subnet.
Each instance that you launch into a default subnet has a private IPv4 address and a public IPv4 address.
These instances can communicate with the internet through the internet gateway.
An internet gateway enables your instances to connect to the internet through the Amazon EC2 network edge.

By default, each instance that you launch into a nondefault subnet has a private IPv4 address, but no public IPv4 address, unless you specifically assign one at launch, or you modify the subnet's public IP address attribute.
These instances can communicate with each other, but can't access the internet.
