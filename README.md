# aws-opentofu
OpenTofu configuration for AWS account setup with GitHub Actions

## OpenTofu stacks

### 0_cicd_oidc_setup

This OpenTofu stack is designed to be run by the initial AWS account holder. This enables the use of GitHub Actions to deploy to the account via infrastructure as code.

This should only need to be run once per AWS account.

