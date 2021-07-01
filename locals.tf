# The default tags configured for the default provider
data "aws_default_tags" "default" {}

locals {
  # Extract the user name of the current caller for use
  # as assume role session names.
  caller_user_name = split("/", data.aws_caller_identity.sharedservices.arn)[1]

  # Get Shared Services account ID from the default provider
  this_account_id = data.aws_caller_identity.sharedservices.account_id

  # Look up Shared Services account name from AWS organizations
  # provider
  this_account_name = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.name
    if account.id == local.this_account_id
  ][0]

  # Determine Shared Services account type based on account name.
  #
  # The account name format is "ACCOUNT_NAME (ACCOUNT_TYPE)" - for
  # example, "Shared Services (Production)".
  this_account_type = length(regexall("\\(([^()]*)\\)", local.this_account_name)) == 1 ? regex("\\(([^()]*)\\)", local.this_account_name)[0] : "Unknown"

  workspace_type = lower(local.this_account_type)

  # Determine the ID of the corresponding Images account
  images_account_id = [
    for account in data.aws_organizations_organization.cool.accounts :
    account.id
    if account.name == "Images (${local.this_account_type})"
  ][0]

  nessus_parameterstorereadonly_role_description = format("Allows read-only access to Nessus-related SSM Parameter Store parameters required for the %s account.", local.this_account_name)

  nessus_parameterstorereadonly_role_name = "ParameterStoreReadOnly-SharedServices-Nessus"

  # The subnet where the Nessus instance is to be placed
  nessus_subnet_cidr = keys(data.terraform_remote_state.networking.outputs.private_subnets)[0]

  nessus_subnet = data.terraform_remote_state.networking.outputs.private_subnets[local.nessus_subnet_cidr]

  # Calculate the VPN server CIDR block using the
  # sharedservices_networking remote state
  #
  # Swiped from:
  # https://github.com/cisagov/cool-sharedservices-openvpn/blob/develop/openvpn.tf#L30-L43
  #
  # OpenVPN currently only uses a single public subnet, so grab the
  # CIDR of the one with the smallest third octet.
  #
  # It's tempting to just use keys()[0] here, but the keys are sorted
  # lexicographically.  That means that "10.1.10.0/24" would come
  # before "10.1.9.0/24".
  cool_public_subnet_cidrs = keys(data.terraform_remote_state.networking.outputs.public_subnets)

  cool_public_subnet_first_octet  = split(".", local.cool_public_subnet_cidrs[0])[0]
  cool_public_subnet_second_octet = split(".", local.cool_public_subnet_cidrs[0])[1]
  cool_public_subnet_third_octets = [for cidr in local.cool_public_subnet_cidrs : split(".", cidr)[2]]

  # This flatten([]) shouldn't be necessary, but it is.  I think this
  # is related to hashicorp/terraform#22404.
  lowest_third_octet = min(flatten([local.cool_public_subnet_third_octets])...)

  vpn_server_cidr_block = format("%d.%d.%d.0/24", local.cool_public_subnet_first_octet, local.cool_public_subnet_second_octet, local.lowest_third_octet)
}
