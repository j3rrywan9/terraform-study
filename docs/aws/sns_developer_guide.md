# Amazon Simple Notification Service Developer Guide

## What is Amazon SNS?

Amazon Simple Notification Service (Amazon SNS) is a managed service that provides message delivery from publishers to subscribers (also known as *producers* and *consumers*).
Publishers communicate asynchronously with subscribers by sending messages to a topic, which is a logical access point and communication channel.
Clients can subscribe to the SNS topic and receive published messages using a supported endpoint type, such as Amazon Kinesis Data Firehose, Amazon SQS, AWS Lambda, HTTP, email, mobile push notifications, and mobile text messages (SMS).

## Amazon SNS event sources and destinations

### Amazon SNS event sources

#### Compute services

| AWS service | Benefit of using with Amazon SNS |
| --- | --- |
| Amazon EC2 Auto Scaling | Receive notifications when Auto Scaling launches or terminates Amazon EC2 instances in your Auto Scaling group. |

#### Container services

| AWS service | Benefit of using with Amazon SNS |
| --- | --- |
| Amazon ECS | |

#### Database services

| AWS service | Benefit of using with Amazon SNS |
| --- | --- |
| Amazon RDS | |

## Getting started with Amazon SNS

## Configuring Amazon SNS

### Creating an Amazon SNS topic

An Amazon SNS topic is a logical access point that acts as a communication channel.
A topic lets you group multiple endpoints (such as AWS Lambda, Amazon SQS, HTTP/S, or an email address).

To broadcast the messages of a message-producer system (for example, an e-commerce website) working with multiple other services that require its messages (for example, checkout and fulfillment systems), you can create a topic for your producer system.

The first and most common Amazon SNS task is creating a topic.
This page shows how you can use the AWS Management Console, the AWS SDK for Java, and the AWS SDK for .NET to create a topic.

During creation, you choose a topic type (standard or FIFO) and name the topic.
After creating a topic, you can't change the topic type or name.
All other configuration choices are optional during topic creation, and you can edit them later.

## Amazon SNS security

### Data protection

### Identity and access management in Amazon SNS

Access to Amazon SNS requires credentials that AWS can use to authenticate your requests.
These credentials must have permissions to access AWS resources, such an Amazon SNS topics and messages.
The following sections provide details on how you can use AWS Identity and Access Management (IAM) and Amazon SNS to help secure your resources by controlling access to them. 

#### Authentication

#### Access control

Amazon SNS has its own resource-based permissions system that uses policies written in the same language used for AWS Identity and Access Management (IAM) policies.
This means that you can achieve similar things with Amazon SNS policies and IAM policies.
