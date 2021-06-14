# The provider used to provision resources in the Shared Services account.
provider "aws" {
  default_tags {
    tags = var.tags
  }
  profile = "cool-sharedservices-provisionaccount"
  region  = var.aws_region
}

# The provider used to lookup account IDs.
provider "aws" {
  alias = "organizationsreadonly"
  assume_role {
    role_arn     = data.terraform_remote_state.master.outputs.organizationsreadonly_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}

# The provider used to create roles that can read parameter data
# from an SSM Parameter Store.
provider "aws" {
  alias = "provisionparameterstorereadrole"
  assume_role {
    role_arn     = data.terraform_remote_state.images_parameterstore.outputs.provisionparameterstorereadroles_role.arn
    session_name = local.caller_user_name
  }
  default_tags {
    tags = var.tags
  }
  region = var.aws_region
}
