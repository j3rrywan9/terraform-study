# Amazon Rational Database Service User Guide

## What is Amazon RDS?

### Overview of Amazon RDS

### DB Instances

The basic building block of Amazon RDS is the DB instance.
A *DB instance* is an isolated database environment in the AWS Cloud.
Your DB instance can contain multiple user-created databases.
You can access your DB instance by using the same tools and applications that you use with a standalone database instance.
You can create and modify a DB instance by using the AWS Command Line Interface, the Amazon RDS API, or the AWS Management Console. 

### AWS Regions and Availability Zones

Amazon cloud computing resources are housed in highly available data center facilities in different areas of the world (for example, North America, Europe, or Asia).
Each data center location is called an AWS Region.

Each AWS Region contains multiple distinct locations called Availability Zones, or AZs.

You can run your DB instance in several Availability Zones, an option called a Multi-AZ deployment.
When you choose this option, Amazon automatically provisions and maintains a secondary standby DB instance in a different Availability Zone.
Your primary DB instance is synchronously replicated across Availability Zones to the secondary instance.
This approach helps provide data redundancy and failover support, eliminate I/O freezes, and minimize latency spikes during system backups.
For more information, see High availability (Multi-AZ) for Amazon RDS. 

### Security


