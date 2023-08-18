# AWS Lambda Developer Guide

## What is AWS Lambda?

Lambda is a computer service that lets you run code without provisioning or managing servers.

## Invoking AWS Lambda functions

### AWS Lambda event source mapping

An event source mapping is an AWS Lambda resource that reads from an event source and invokes a Lambda function.
You can use event source mappings to process items from a stream or queue in services that don't invoke Lambda functions directly.
Lambda provides event source mappings for the following services. 

Services that Lambda reads events from
* Amazon DynamoDB
* Amazon Kinesis
* Amazon MQ
* Amazon Managed Streaming for Apache Kafka
* self-managed Apache Kafka
* Amazon Simple Queue Service

An event source mapping uses permissions in the function's execution role to read and manage items in the event source.
Permissions, event structure, settings, and polling behavior vary by event source.
For more information, see the linked topic for the service that you use as an event source.
