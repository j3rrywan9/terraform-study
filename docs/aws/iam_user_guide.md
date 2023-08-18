# AWS Identity and Access Management User Guide

## What is IAM?

AWS Identity and Access Management (IAM) is a web service that helps you securely control access to AWS resources.
You use IAM to control who is authenticated (signed in) and authorized (has permissions) to use resources.

When you first create an AWS account, you begin with a single sign-in identity that has complete access to all AWS services and resources in the account.
This identity is called the AWS account *root user* and is accessed by signing in with the email address and password that you used to create the account.
We strongly recommend that you do not use the root user for your everyday tasks, even the administrative ones.
Instead, adhere to the best practice of using the root user only to create your first IAM user.
Then securely lock away the root user credentials and use them to perform only a few account and service management tasks.

## IAM Identities (users, user groups, and roles)

### AWS account root user

### IAM roles

### Using service-linked roles

A service-linked role is a unique type of IAM role that is linked directly to an AWS service.
Service-linked roles are predefined by the service and include all the permissions that the service requires to call other AWS services on your behalf.
The linked service also defines how you create, modify, and delete a service-linked role.
A service might automatically create or delete the role.
It might allow you to create, modify, or delete the role as part of a wizard or process in the service.
Or it might require that you use IAM to create or delete the role.
Regardless of the method, service-linked roles make setting up a service easier because you don't have to manually add the necessary permissions for the service to complete actions on your behalf.

The linked service defines the permissions of its service-linked roles, and unless defined otherwise, only that service can assume the roles.
The defined permissions include the trust policy and the permissions policy, and that permissions policy cannot be attached to any other IAM entity. 
