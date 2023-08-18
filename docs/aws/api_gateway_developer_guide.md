# Amazon API Gateway

## What is Amazon API Gateway?

Amazon API Gateway is an AWS service for creating, publishing, maintaining, monitoring, and securing REST, HTTP, and WebSocket APIs at any scale.
API developers can create APIs that access AWS or other web services, as well as data stored in the AWS Cloud.
As an API Gateway API developer, you can create APIs for use in your own client applications.
Or you can make your APIs available to third-party app developers.

API Gateway creates RESTful APIs that:
* Are HTTP-based
* Enable stateless client-server communication
* Implement standard HTTP methods such as GET, POST, PUT, PATCH, and DELETE.

### Architecture of API Gateway

## Amazon API Gateway Tutorials and workshops

### Amazon API Gateway REST API tutorials

#### Build an API Gateway REST API with Lambda integration

To build an API with Lambda integrations, you can use Lambda proxy integration or Lambda non-proxy integration.

In Lambda proxy integration, the input to the integrated Lambda function can be expressed as any combination of request headers, path variables, query string parameters, and body.
In addition, the Lambda function can use API configuration settings to influence its execution logic.
For an API developer, setting up a Lambda proxy integration is simple.
Other than choosing a particular Lambda function in a given region, you have little else to do.
API Gateway configures the integration request and integration response for you.
Once set up, the integrated API method can evolve with the backend without modifying the existing settings.
This is possible because the backend Lambda function developer parses the incoming request data and responds with desired results to the client when nothing goes wrong or responds with error messages when anything goes wrong.

In Lambda non-proxy integration, you must ensure that input to the Lambda function is supplied as the integration request payload.
This implies that you, as an API developer, must map any input data the client supplied as request parameters into the proper integration request body.
You may also need to translate the client-supplied request body into a format recognized by the Lambda function.

## Working with HTTP APIs

## Working with REST APIs

### Developing a REST API in API Gateway

This section provides details about API Gateway capabilities that you need while you're developing your API Gateway APIs.

As you're developing your API Gateway API, you decide on a number of characteristics of your API.
These characteristics depend on the use case of your API.
For example, you might want to only allow certain clients to call your API, or you might want it to be available to everyone.
You might want an API call to execute a Lambda function, make a database query, or call an application.

### Publishing REST APIs for customers to invoke

Simply creating and developing an API Gateway API doesn't automatically make it callable by your users.
To make it callable, you must deploy your API to a stage.
In addition, you might want to customize the URL that your users will use to access your API.
You can give it a domain that is consistent with your brand or is more memorable than the default URL for your API.

#### Deploying a REST API in Amazon API Gateway

After creating your API, you must deploy it to make it callable by your users.

To deploy an API, you create an API deployment and associate it with a stage.
A stage is a logical reference to a lifecycle state of your API (for example, `dev`, `prod`, `beta`, `v2`).
API stages are identified by the API ID and stage name.
They're included in the URL that you use to invoke the API.
Each stage is a named reference to a deployment of the API and is made available for client applications to call. 

As your API evolves, you can continue to deploy it to different stages as different versions of the API.
You can also deploy your API updates as a canary release deployment.
This enables your API clients to access, on the same stage, the production version through the production release, and the updated version through the canary release.

To call a deployed API, the client submits a request against an API's URL.
The URL is determined by an API's protocol (HTTP(S) or (WSS)), hostname, stage name, and (for REST APIs) resource path.
The hostname and the stage name determine the API's base URL.

Using the API's default domain name, the base URL of a REST API (for example) in a given stage (`{stageName}`) is in the following format:
```
https://{restapi-id}.execute-api.{region}.amazonaws.com/{stageName}
```

For each stage, you can optimize API performance by adjusting the default account-level request throttling limits and enabling API caching.
You can also enable logging for API calls to CloudTrail or CloudWatch, and can select a client certificate for the backend to authenticate the API requests.
In addition, you can override stage-level settings for individual methods and define stage variables to pass stage-specific environment contexts to the API integration at runtime

Stages enable robust version control of your API.
For example, you can deploy an API to a `test` stage and a `prod` stage, and use the `test` stage as a test build and use the `prod` stage as a stable build.
After the updates pass the test, you can promote the `test` stage to the `prod` stage.
The promotion can be done by redeploying the API to the `prod` stage or updating a stage variable value from the stage name of `test` to that of `prod`.

#### Deploy a REST API

In API Gateway, a REST API deployment is represented by a Deployment resource.
It's similar to an executable of an API that is represented by a RestApi resource. 

For the client to call your API, you must create a deployment and associate a stage with it.
A stage is represented by a Stage resource.
It represents a snapshot of the API, including methods, integrations, models, mapping templates, and Lambda authorizers (formerly known as custom authorizers).
When you update the API, you can redeploy the API by associating a new stage with the existing deployment.
We discuss creating a stage in Setting up a stage for a REST API. 

### Use Lambda authorizers

A *Lambda authorizer* (formerly known as a *custom authorizer*) is an API Gateway feature that uses a Lambda function to control access to your API.

A Lambda authorizer is useful if you want to implement a custom authorization scheme that uses a bearer token authentication strategy such as OAuth or SAML, or that uses request parameters to determine the caller's identity.

When a client makes a request to one of your API's methods, API Gateway calls your Lambda authorizer, which takes the caller's identity as input and returns an IAM policy as output.

There are two types of Lambda authorizers:
* A *token-based* Lambda authorizer (also called a `TOKEN` authorizer) receives the caller's identity in a bearer token, such as a JSON Web Token (JWT) or an OAuth token.
* A *request parameter-based* Lambda authorizer (also called a REQUEST authorizer) receives the caller's identity in a combination of headers, query string parameters, `stageVariables`, and `$context` variables. For WebSocket APIs, only request parameter-based authorizers are supported.

It is possible to use an AWS Lambda function from an AWS account that is different from the one in which you created your API.
For more information, see Configure a cross-account Lambda authorizer. 
