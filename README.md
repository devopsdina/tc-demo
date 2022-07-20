# tc-demo

This code shows examples for:
- Github actions to create workspaces in Terraform cloud
- Github actions to create variables (sensitive and non-sensitive) in Terraform cloud
- Terraform code to deploy a web server in AWS
- Terraform code to deploy a web server in Azure

## Pre-reqs

- There are secrets that must be set in order to run the workflows.

**THE FOLLOWING MUST BE SET AS REPOSITORY SECRETS:**

`TOKEN` - This is the API token to communicate to Terraform cloud

`OAUTH_TOKEN_ID` - This is the OAuth token given by Terraform cloud once the connection is established with Github

_You must create a service principal in Azure_

`ARM_CLIENT_ID` - The client id of the service principal

`ARM_CLIENT_SECRET` - The client secret of the service principal

`ARM_SUBSCRIPTION_ID` - The subscription ID in Azure

`ARM_TENANT_ID` - The azure tenant ID

_In AWS_

`AWS_ACCESS_KEY` - AWS access key

`AWS_SECRET_KEY` - AWS secret key

For the Azure VM there is a username and password associated with it.  You must set the following secrets for it:
`ADMIN_USERNAME` - Username for login

`ADMIN_PASSWORD` - Password for login