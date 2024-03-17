# 0_cicd_oidc_setup

This OpenTofu stack is designed to be run by the initial AWS account holder. This enables the use of GitHub Actions to deploy to the account via infrastructure as code. 

You can think of this as a bootstrapping landing zone. Any other resources deployed for applications should be done in another repo.

## Setup

1. Download the AWS CLI
1. Login to the AWS Management Console using the root user, visit the IAM service. Visit the ["My security credentials"](https://us-east-1.console.aws.amazon.com/iam/home#/security_credentials) section.
1. Click "Create access key" under the "Access keys" section.
1. Accept the bad practice warning checkbox and click "Create access key".
1. Save the "Access key" and "Secret access key" information.
1. Use `aws configure` to setup your credential access. Use the information from the previous step to configure.
1. Test to see if you have account credentials.

```bash
$ aws sts get-caller-identity
{
    "UserId": "851725648404",
    "Account": "851725648404",
    "Arn": "arn:aws:iam::851725648404:root"
}
```

1. Run this OpenTofu stack.
```bash
tofu init
tofu apply
```

1. Once completed, navigate back to the AWS Management Console and visit the ["My security credentials"](https://us-east-1.console.aws.amazon.com/iam/home#/security_credentials) section again.
1. Select the access key id you created previously.
1. In the "Actions" drop-down menu, click "Delete".
1. In the popup modal, click "Deactivate" and then type in the access key ID to confirm. Click "Delete".
