# cool-sharedservices-nessus #

[![GitHub Build Status](https://github.com/cisagov/cool-sharedservices-nessus/workflows/build/badge.svg)](https://github.com/cisagov/cool-sharedservices-nessus/actions)

This is Terraform for creating a Nessus instance in the COOL Shared Services
account.  This deployment should be laid down on top of
[cisagov/cool-sharedservices-networking](https://github.com/cisagov/cool-sharedservices-networking),
after
[cisagov/cool-sharedservices-freeipa](https://github.com/cisagov/cool-sharedservices-freeipa)
and
[cisagov/cool-sharedservices-openvpn](https://github.com/cisagov/cool-sharedservices-openvpn)
have been applied.

## Requirements ##

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
| aws | ~> 3.0 |
| cloudinit | ~> 2.0 |

## Providers ##

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| aws.organizationsreadonly | ~> 3.0 |
| aws.provisionparameterstorereadrole | ~> 3.0 |
| cloudinit | ~> 2.0 |
| terraform | n/a |

## Inputs ##

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region to deploy into (e.g. us-east-1) | `string` | `us-east-1` | no |
| create_nessus_instance | A boolean that determines whether or not to create the Nessus instance | `bool` | `false` | no |
| nessus_activation_code | The Nessus activation code (e.g. "AAAA-BBBB-CCCC-DDDD") | `string` | `` | no |
| ssm_key_nessus_admin_password | The AWS SSM Parameter Store parameter that contains the password of the Nessus admin user (e.g. "/nessus/sharedservices/admin_password") | `string` | `/nessus/sharedservices/admin_password` | no |
| ssm_key_nessus_admin_username | The AWS SSM Parameter Store parameter that contains the username of the Nessus admin user (e.g. "/nessus/sharedservices/admin_username") | `string` | `/nessus/sharedservices/admin_username` | no |
| tags | Tags to apply to all AWS resources created | `map(string)` | `{}` | no |

## Outputs ##

| Name | Description |
|------|-------------|
| instance_id | The Nessus EC2 instance ID |
| security_group_id | The ID corresponding to the Nessus security group |

## Notes ##

Running `pre-commit` requires running `terraform init` in every directory that
contains Terraform code. In this repository, this is only the main directory.

## Contributing ##

We welcome contributions!  Please see [here](CONTRIBUTING.md) for
details.

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
